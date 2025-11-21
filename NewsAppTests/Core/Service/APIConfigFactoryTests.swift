//
//  APIConfigFactoryTests.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Testing
import Foundation
@testable import NewsApp

struct APIConfigFactoryTests {
    
    @Test("Returns development config for debug build configuration")
    func testMakeConfigReturnsDevelopmentConfigForDebug() {
        // Act
        let config = APIConfigFactory.makeConfig(for: .debug)
        
        // Assert
        #expect(config is DevelopmentAPIConfig)
    }
    
    @Test("Returns production config for release build configuration")
    func testMakeConfigReturnsProductionConfigForRelease() {
        // Act
        let config = APIConfigFactory.makeConfig(for: .release)
        
        // Assert
        #expect(config is ProductionAPIConfig)
    }
}

