//
//  DIAssembly.swift
//  NewsApp
//
//  Created by Murtuza Saify on 19/11/2025.
//

import Foundation

enum DIAssembly {
    static func build() -> DIContainer {
        let container = DefaultDIContainer()
        
        return container
    }
}
