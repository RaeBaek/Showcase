//
//  PagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/27/25.
//

import Combine

import NetworkModel

public protocol PagingUseCase<Entity>: AnyObject {
    associatedtype Entity: Identifiable where Entity.ID == Int
    var items: [Entity] { get }
    var hasNext: Bool { get }

    var itemsPublisher: AnyPublisher<[Entity], Never> { get }

    func loadFirst() async throws
    func loadMoreIfNeeded(currentItem: Entity, threshold: Int) async
}
