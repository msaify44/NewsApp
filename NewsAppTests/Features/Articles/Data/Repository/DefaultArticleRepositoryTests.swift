//
//  DefaultArticleRepositoryTests.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Testing
import Foundation
@testable import NewsApp

// MARK: - DefaultArticleRepository Tests

@MainActor
struct DefaultArticleRepositoryTests {
    
    // MARK: - Success Cases
    
    @Test("Successfully fetches and maps articles")
    func testFetchMostViewedArticlesSuccess() async throws {
        let mockDatasource = MockArticleRemoteDatasource()
        let repository = DefaultArticleRepository(datasource: mockDatasource)
        
        let expectedArticles = createMockArticles()
        mockDatasource.mockResult = ArticleResultsDTO(results: createMockArticleDTOs())
        
        let result = try await repository.fetchMostViewedArticles(for: .oneDay)
        
        #expect(result.count == expectedArticles.count)
        #expect(result[0].id == expectedArticles[0].id)
    }
    
    @Test("Correctly maps ArticleDTO to Article domain model")
    func testArticleMapping() async throws {
        let mockDatasource = MockArticleRemoteDatasource()
        let repository = DefaultArticleRepository(datasource: mockDatasource)
        
        let articleDTOs = [
            ArticleDTO(
                id: 123,
                title: "Test Article",
                abstract: "Test Abstract",
                publishedDate: "10-10-2025",
                byline: "Test Author",
                media: MediaDTO(metadata: [
                    MediaMetadataDTO(url: "https://example.com/thumb.jpg", format: .thumbnail),
                    MediaMetadataDTO(url: "https://example.com/large.jpg", format: .medium210)
                ])
            )
        ]
        
        mockDatasource.mockResult = ArticleResultsDTO(results: articleDTOs)
        
        let result = try await repository.fetchMostViewedArticles(for: .oneDay)
        
        #expect(result.count == 1)
        #expect(result[0].id == 123)
        #expect(result[0].title == "Test Article")
        #expect(result[0].abstract == "Test Abstract")
        #expect(result[0].byLine == "Test Author")
        #expect(result[0].thumbnailUrl == "https://example.com/thumb.jpg")
        #expect(result[0].largeImageUrl == "https://example.com/large.jpg")
    }
    
    // MARK: - Error Cases
    
    @Test("Propagates datasource errors correctly")
    func testFetchMostViewedArticlesPropagatesError() async throws {
        let mockDatasource = MockArticleRemoteDatasource()
        let repository = DefaultArticleRepository(datasource: mockDatasource)
        
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockDatasource.mockError = expectedError
        
        do {
            _ = try await repository.fetchMostViewedArticles(for: .oneDay)
            Issue.record("Expected error to be thrown")
        } catch {
            #expect((error as NSError).code == expectedError.code)
            #expect((error as NSError).domain == expectedError.domain)
        }
    }
    
    @Test("Propagates network errors correctly")
    func testFetchMostViewedArticlesNetworkError() async throws {
        let mockDatasource = MockArticleRemoteDatasource()
        let repository = DefaultArticleRepository(datasource: mockDatasource)
        
        struct NetworkError: Error {
            let message: String
        }
        
        let networkError = NetworkError(message: "Connection failed")
        mockDatasource.mockError = networkError
        
        do {
            _ = try await repository.fetchMostViewedArticles(for: .week)
            Issue.record("Expected error to be thrown")
        } catch let error as NetworkError {
            #expect(error.message == "Connection failed")
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}

// MARK: - Mock ArticleRemoteDatasource

final class MockArticleRemoteDatasource: ArticleRemoteDatasource {
    var mockResult: ArticleResultsDTO?
    var mockError: Error?
    
    func fetchMostViewedArticles(for period: Period) async throws -> ArticleResultsDTO {
        
        if let error = mockError {
            throw error
        }
        
        guard let result = mockResult else {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock result set"])
        }
        
        return result
    }
}

// MARK: - Test Helpers

private extension DefaultArticleRepositoryTests {
    func createMockArticleDTOs() -> [ArticleDTO] {
        [
            ArticleDTO(
                id: 1,
                title: "First Article",
                abstract: "First Abstract",
                publishedDate: "10-10-2025",
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
                publishedDate: "10-10-2025",
                byline: "Second Author",
                media: MediaDTO(metadata: [
                    MediaMetadataDTO(url: "https://example.com/thumb2.jpg", format: .thumbnail),
                    MediaMetadataDTO(url: "https://example.com/large2.jpg", format: .medium210)
                ])
            )
        ]
    }
    
    func createMockArticles() -> [Article] {
        [
            Article(
                id: 1,
                title: "First Article",
                abstract: "First Abstract",
                publishedDate: "10-10-2025",
                thumbnailUrl: "https://example.com/thumb1.jpg",
                largeImageUrl: "https://example.com/large1.jpg",
                byLine: "First Author"
            ),
            Article(
                id: 2,
                title: "Second Article",
                abstract: "Second Abstract",
                publishedDate: "10-10-2025",
                thumbnailUrl: "https://example.com/thumb2.jpg",
                largeImageUrl: "https://example.com/large2.jpg",
                byLine: "Second Author"
            )
        ]
    }
}

