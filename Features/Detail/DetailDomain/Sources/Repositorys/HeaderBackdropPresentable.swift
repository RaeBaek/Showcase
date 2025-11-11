//
//  HeaderBackdropPresentable.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

public protocol HeaderBackdropPresentable {
    var titleText: String { get }
    var originalTitleText: String? { get }
    var ratingText: String { get }
    var metaText: String { get }
    var genresText: String { get }
    var posterURL: URL? { get }
    var backdropURL: URL? { get }
    var overviewText: String { get }
}
