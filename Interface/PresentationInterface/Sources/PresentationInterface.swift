//
//  DomainErrorMessageMapper.swift
//  PresentationInterface
//
//  Created by 백래훈 on 12/2/25.
//

import DomainInterface

public struct DomainErrorMessageMapper {
    public static func message(for error: DomainError) -> String {
        switch error {
        case .network:
            return "인터넷 연결이 불안정합니다. 네트워크 상태를 확인해주세요."
        case .timeout:
            return "응답이 지연되고 있어요. 잠시 후 다시 시도해주세요."
        case .unauthorized:
            return "접근 권한이 없습니다."
        case .forbidden:
            return "요청이 거부되었어요."
        case .notFound:
            return "요청한 데이터를 찾을 수 없습니다."
        case .tooManyRequests:
            return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요."
        case .serverError:
            return "서버에 문제가 발생했습니다."
        case .decoding:
            return "데이터를 처리할 수 없습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}
