//
//  HorizontalContentDisplayable.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/21/25.
//

import Foundation

public protocol HorizontalContentDisplayable: Identifiable {
    var posterURL: URL? { get }
    var titleText: String { get }
    var infoText: String? { get }
}
