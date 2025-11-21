//
//  DefaultArticleRemoteDatasourceTests.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Testing
import Foundation
@testable import NewsApp

// MARK: - DefaultArticleRemoteDatasource Tests

@MainActor
struct DefaultArticleRemoteDatasourceTests {
    
    // MARK: - Success Cases
    
    @Test("Successfully fetches articles")
    func testFetchMostViewedArticlesSuccess() async throws {
        // Arrange
        let mockService = MockServiceClient()
        let apiConfig = TestMocks.makeAPIConfig(baseURL: URL(string: "https://api.nytimes.com")!, apiKey: "TEST-KEY")
        let datasource = DefaultArticleRemoteDatasource(service: mockService, apiConfig: apiConfig)
        
        let expectedResult = TestMocks.createMockArticleResultsDTO()
        mockService.mockResult = expectedResult
        
        // Act
        let result = try await datasource.fetchMostViewedArticles(for: .oneDay)
        
        // Assert
        #expect(result.results.count == expectedResult.results.count)
        #expect(result.results[0].id == expectedResult.results[0].id)
        #expect(result.results[0].title == expectedResult.results[0].title)
        #expect(mockService.lastDescriptor?.path.contains("1.json") == true)
    }
    
    @Test("Creates correct URL descriptor for period")
    func testCreatesCorrectURLDescriptor() async throws {
        // Arrange
        let mockService = MockServiceClient()
        let apiConfig = TestMocks.makeAPIConfig(baseURL: URL(string: "https://api.nytimes.com")!, apiKey: "TEST-KEY")
        let datasource = DefaultArticleRemoteDatasource(service: mockService, apiConfig: apiConfig)
        
        mockService.mockResult = TestMocks.createMockArticleResultsDTO()
        
        // Act
        _ = try await datasource.fetchMostViewedArticles(for: .oneDay)
        
        // Assert
        guard let descriptor = mockService.lastDescriptor as? FetchMostViewedArticlesURLDescriptor else {
            Issue.record("Expected MostViewArticlesURLDescriptor")
            return
        }
        
        #expect(descriptor.path.contains("1.json"))
        #expect(descriptor.host.absoluteString == "https://api.nytimes.com")
        #expect(descriptor.method == .get)
    }
    
    // MARK: - Error Cases
    
    @Test("Propagates errors from service client")
    func testPropagatesError() async throws {
        // Arrange
        let mockService = MockServiceClient()
        let datasource = DefaultArticleRemoteDatasource(service: mockService, apiConfig: TestMocks.makeAPIConfig())
        
        let transportError = TestMocks.createMockTransportError()
        mockService.mockError = ServiceError.transport(transportError)
        
        // Act
        do {
            _ = try await datasource.fetchMostViewedArticles(for: .oneDay)
            Issue.record("Expected error to be thrown")
        } catch let error as ServiceError {
            // Assert
            if case .transport(let underlyingError) = error {
                #expect((underlyingError as? URLError)?.code == .notConnectedToInternet)
            } else {
                Issue.record("Expected transport error")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}


