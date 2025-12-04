//
//  LoadState.swift
//  DetailDomain
//
//  Created by 백래훈 on 12/2/25.
//

import Foundation

public enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}
