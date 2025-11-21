//
//  MostViewArticlesURLDescriptorTests.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Testing
import Foundation
@testable import NewsApp

// MARK: - MostViewArticlesURLDescriptor Tests

@MainActor
struct MostViewArticlesURLDescriptorTests {
    
    // MARK: - Host Tests
    
    @Test("Returns correct host URL")
    func testReturnsCorrectHost() {
        let descriptor = FetchMostViewedArticlesURLDescriptor(period: .oneDay)
        
        #expect(descriptor.host.absoluteString == "https://api.nytimes.com")
    }
    
    // MARK: - Path Tests
    
    @Test("Path contains correct base path")
    func testPathContainsCorrectBasePath() {
        let descriptor = FetchMostViewedArticlesURLDescriptor(period: .oneDay)
        
        #expect(descriptor.path.contains("svc/mostpopular/v2/mostviewed/all-sections"))
    }
    
    // MARK: - Method Tests
    
    @Test("Returns GET method")
    func testReturnsGETMethod() {
        let descriptor = FetchMostViewedArticlesURLDescriptor(period: .oneDay)
        
        #expect(descriptor.method == .get)
    }
    
    // MARK: - Query Items Tests
    
    @Test("Returns query items with API key")
    func testReturnsQueryItemsWithAPIKey() {
        // Arrange
        let apiConfig = DefaultAPIConfig()
        let descriptor = FetchMostViewedArticlesURLDescriptor(period: .oneDay,
                                                       apiConfig: apiConfig)
        
        // Act
        guard let queryItems = descriptor.queryItems else {
            Issue.record("Expected query items to be present")
            return
        }
        
        // Assert
        #expect(queryItems.count == 1)
        #expect(queryItems[0].name == "api-key")
        #expect(queryItems[0].value == apiConfig.apiKey)
    }
    
    
    // MARK: - URLRequest Building Tests
    
    @Test("Built URLRequest has correct full URL")
    func testBuiltURLRequestHasCorrectFullURL() throws {
        // Arrange
        let apiConfig = DefaultAPIConfig()
        let descriptor = FetchMostViewedArticlesURLDescriptor(period: .oneDay, apiConfig: apiConfig)
        let request = try descriptor.buildURLRequest()
        
        // Act
        guard let url = request.url else {
            Issue.record("Expected URL to be present")
            return
        }
        
        // Assert
        #expect(url.host == apiConfig.baseURL.host)
        #expect(url.path() == "/svc/mostpopular/v2/mostviewed/all-sections/1.json")
        #expect(url.query()?.contains("api-key=\(apiConfig.apiKey)") == true)
    }
}

