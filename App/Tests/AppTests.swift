//
//  AppTests.swift
//  App
//
//  Created by 백래훈 on 10/23/25.
//

import XCTest
@testable import App

/// React Native의 비슷한 작품 선택을 SwiftUI가 받아들이는 조건을 검증합니다.
final class AppTests: XCTestCase {
    private let requestID = UUID()

    /// 현재 시트의 목록에 있는 작품을 선택하면 해당 영화 ID를 반환하는지 확인합니다.
    func test_similarMovieSelection_acceptsMovieInCurrentSheet() {
        XCTAssertEqual(selectedMovieID("42", eventRequestID: requestID), 42)
    }

    /// 이전 시트에서 늦게 전달된 선택을 무시하는지 확인합니다.
    func test_similarMovieSelection_rejectsPreviousSheetRequest() {
        XCTAssertNil(selectedMovieID("42", eventRequestID: UUID()))
    }

    /// 숫자로 변환할 수 없는 영화 ID를 거부하는지 확인합니다.
    func test_similarMovieSelection_rejectsNonNumericMovieID() {
        XCTAssertNil(selectedMovieID("invalid", eventRequestID: requestID))
    }

    /// 작품이 목록에 있어도 상세 경로의 Int32 범위를 벗어나면 거부하는지 확인합니다.
    func test_similarMovieSelection_rejectsOutOfRangeMovieID() {
        let outOfRangeID = Int(Int32.max) + 1
        XCTAssertNil(selectedMovieID(
            String(outOfRangeID),
            eventRequestID: requestID,
            allowedMovieIDs: [outOfRangeID]
        ))
    }

    /// 현재 시트의 요청 ID가 일치해도 목록에 없는 작품을 거부하는지 확인합니다.
    func test_similarMovieSelection_rejectsMovieOutsideCurrentList() {
        XCTAssertNil(selectedMovieID("43", eventRequestID: requestID))
    }

    /// RN 선택 알림과 같은 형태의 입력을 만들어 실제 검증 함수에 전달합니다.
    private func selectedMovieID(
        _ movieID: String,
        eventRequestID: UUID,
        allowedMovieIDs: Set<Int> = [42]
    ) -> Int32? {
        let notification = Notification(
            name: .init("ShowcaseSimilarMovieSelected"),
            object: eventRequestID.uuidString,
            userInfo: ["movieID": movieID]
        )
        return SimilarMovieSelection.movieID(
            from: notification,
            requestID: requestID,
            allowedMovieIDs: allowedMovieIDs
        )
    }
}
