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
        let mockService = MockServiceClient()
        let datasource = DefaultArticleRemoteDatasource(service: mockService)
        
        let expectedResult = createMockArticleResultsDTO()
        mockService.mockResult = expectedResult
        
        let result = try await datasource.fetchMostViewedArticles(for: .oneDay)
        
        #expect(result.results.count == expectedResult.results.count)
        #expect(result.results[0].id == expectedResult.results[0].id)
        #expect(result.results[0].title == expectedResult.results[0].title)
        #expect(mockService.lastDescriptor?.path.contains("1.json") == true)
    }
    
    @Test("Creates correct URL descriptor for period")
    func testCreatesCorrectURLDescriptor() async throws {
        let mockService = MockServiceClient()
        let datasource = DefaultArticleRemoteDatasource(service: mockService)
        
        mockService.mockResult = createMockArticleResultsDTO()
        
        _ = try await datasource.fetchMostViewedArticles(for: .oneDay)
        
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
        let mockService = MockServiceClient()
        let datasource = DefaultArticleRemoteDatasource(service: mockService)
        
        let transportError = URLError(.notConnectedToInternet)
        mockService.mockError = ServiceError.transport(transportError)
        
        do {
            _ = try await datasource.fetchMostViewedArticles(for: .oneDay)
            Issue.record("Expected error to be thrown")
        } catch let error as ServiceError {
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

// MARK: - Mock ServiceClient

final class MockServiceClient: ServiceClient {
    var mockResult: ArticleResultsDTO?
    var mockError: Error?
    var lastDescriptor: URLDescriptor?
    var callCount: Int = 0
    
    func performRequest<T: Decodable>(descriptor: URLDescriptor) async throws -> T {
        callCount += 1
        lastDescriptor = descriptor
        
        if let error = mockError {
            throw error
        }
        
        guard let result = mockResult as? T else {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock result set or type mismatch"])
        }
        
        return result
    }
}

// MARK: - Test Helpers

private extension DefaultArticleRemoteDatasourceTests {
    func createMockArticleResultsDTO() -> ArticleResultsDTO {
        ArticleResultsDTO(results: [
            ArticleDTO(
                id: 1,
                title: "First Article",
                abstract: "First Abstract",
                publishedDate: "2025-10-01",
                byline: "First Author",
                media: MediaDTO(metadata: [
                    MediaMetadataDTO(url: "https://example.com/thumb1.jpg", format: .thumbnail),
                    MediaMetadataDTO(url: "https://example.com/large1.jpg", format: .medium210)
                ])
            ),
            ArticleDTO(
                id: 2,
                title: "Second Article",
                abstract: "Second Abstract",
                publishedDate: "2025-10-02",
                byline: "Second Author",
                media: MediaDTO(metadata: [
                    MediaMetadataDTO(url: "https://example.com/thumb2.jpg", format: .thumbnail),
                    MediaMetadataDTO(url: "https://example.com/large2.jpg", format: .medium210)
                ])
            )
        ])
    }
}

