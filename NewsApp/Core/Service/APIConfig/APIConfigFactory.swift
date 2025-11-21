//
//  APIConfigFactory.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Foundation

enum APIConfigFactory {
    static func makeConfig(for configuration: BuildConfiguration = .current) -> APIConfig {
        switch configuration {
        case .debug:
            return DevelopmentAPIConfig()
        case .release:
            return ProductionAPIConfig()
        }
    }
}
