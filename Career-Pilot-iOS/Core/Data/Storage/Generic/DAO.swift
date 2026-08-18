//
//  DAO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 18/07/2026.
//

import Foundation

protocol DAO {
    associatedtype Entity
    associatedtype ID: Hashable

    func create(_ entity: Entity) throws
    func read(id: ID) throws -> Entity?
    func readAll() throws -> [Entity]
    func update(_ entity: Entity) throws
    func delete(id: ID) throws
}
