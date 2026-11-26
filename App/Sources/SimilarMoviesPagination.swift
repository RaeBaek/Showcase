//
//  SimilarMoviesPagination.swift
//  Showcase
//
//  Created by 백래훈 on 11/26/26.
//

import Foundation

import DetailDomain

@MainActor
@objc(ShowcaseSimilarMoviesPagination)
final class SimilarMoviesPagination: NSObject {
    private static let maxPage = 500
    private static weak var active: SimilarMoviesPagination?

    nonisolated let id = UUID()
    private(set) var allowedMovieIDs: Set<Int>
    private let movieID: Int32
    private let language: String
    private let useCase: MovieDetailUseCase
    private var page: Int
    private var totalPages: Int
    private var loadTask: Task<Void, Never>?

    var hasMore: Bool {
        page >= 1 && page < min(totalPages, Self.maxPage)
    }

    init(movieID: Int32, language: String, initialPage: SimilarMoviesPage, useCase: MovieDetailUseCase) {
        self.movieID = movieID
        self.language = language
        self.useCase = useCase
        page = initialPage.page
        totalPages = initialPage.totalPages
        allowedMovieIDs = Set(initialPage.items.map(\.id))
        super.init()
        Self.active?.cancel()
        Self.active = self
    }

    func cancel() {
        if Self.active === self {
            Self.active = nil
        }
        loadTask?.cancel()
    }

    @objc(requestNextPage:completion:)
    static func requestNextPage(_ requestID: String, completion: @escaping (NSDictionary) -> Void) {
        guard let active, active.id.uuidString == requestID else {
            completion(["status": "inactive", "hasMore": false])
            return
        }
        active.loadNextPage(completion: completion)
    }

    private func loadNextPage(completion: @escaping (NSDictionary) -> Void) {
        guard hasMore else {
            completion(["status": "end", "hasMore": false])
            return
        }
        guard loadTask == nil else {
            completion(["status": "busy", "hasMore": true])
            return
        }

        let nextPage = page + 1
        let input = DetailInput(id: movieID, language: language, page: Int32(nextPage))
        loadTask = Task {
            let result = try? await useCase.fetchSimilar(input)
            loadTask = nil

            guard !Task.isCancelled, Self.active === self else {
                completion(["status": "inactive", "hasMore": false])
                return
            }
            guard let result, result.page == nextPage else {
                completion(["status": "failed", "hasMore": hasMore])
                return
            }

            let newItems = result.items.filter { allowedMovieIDs.insert($0.id).inserted }
            page = result.page
            totalPages = result.totalPages
            completion([
                "status": "loaded",
                "movies": Self.movieProperties(newItems),
                "page": page,
                "hasMore": hasMore
            ])
        }
    }

    static func movieProperties(_ movies: [SimilarItemEntity]) -> [[String: Any]] {
        movies.map { movie in
            [
                "id": movie.id,
                "title": movie.title as Any? ?? NSNull(),
                "originalTitle": movie.originalTitle as Any? ?? NSNull(),
                "posterURL": movie.posterURL?.absoluteString as Any? ?? NSNull()
            ]
        }
    }
}
