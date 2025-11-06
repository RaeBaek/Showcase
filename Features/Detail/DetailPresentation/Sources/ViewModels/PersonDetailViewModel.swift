//
//  PersonDetailViewModel.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation

public final class PersonDetailViewModel: ObservableObject {
    @Published var state: LoadState = .idle
}
