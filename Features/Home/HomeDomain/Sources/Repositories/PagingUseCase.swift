//
//  PagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/27/25.
//

import Foundation

public protocol PagingUseCase<Entity>: AnyObject {
    associatedtype Entity: Identifiable where Entity.ID == Int
    var items: [Entity] { get }
    var hasNext: Bool { get }

    func loadFirst() async throws
    func loadMoreIfNeeded(currentItem: Entity, threshold: Int) async
}
