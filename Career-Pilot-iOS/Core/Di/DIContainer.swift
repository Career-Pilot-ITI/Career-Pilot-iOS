//
//  DIContainer.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation
import Swinject

@MainActor
final class DIContainer{
    static let shared: DIContainer = DIContainer()
    let container = Container()
    
    private init(){
        registerAll()
    }
    
    private func registerAll(){
        registerViewModels()
        registerUseCases()
        registerRepositories()
        registerDataSources()
        registerServices()
    }
}

