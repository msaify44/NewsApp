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
        // Arrange
        let mockDatasource = MockArticleRemoteDatasource()
        let repository = DefaultArticleRepository(datasource: mockDatasource)
        
        let expectedArticles = TestMocks.createMockArticles()
        mockDatasource.mockResult = ArticleResultsDTO(results: TestMocks.createMockArticleDTOs())
        
        // Act
        let result = try await repository.fetchMostViewedArticles(for: .oneDay)
        
        // Assert
        #expect(result.count == expectedArticles.count)
        #expect(result[0].id == expectedArticles[0].id)
    }
    
    @Test("Correctly maps ArticleDTO to Article domain model")
    func testArticleMapping() async throws {
        // Arrange
        let mockDatasource = MockArticleRemoteDatasource()
        let repository = DefaultArticleRepository(datasource: mockDatasource)
        
        let articleDTOs = [
            ArticleDTO(
                id: 123,
                title: "Test Article",
                abstract: "Test Abstract",
                publishedDate: "10-10-2025",
                byline: "Test Author",
                media: [MediaDTO(metadata: [
                    MediaMetadataDTO(url: "https://example.com/thumb.jpg", format: .thumbnail),
                    MediaMetadataDTO(url: "https://example.com/large.jpg", format: .medium440)
                ])]
            )
        ]
        
        mockDatasource.mockResult = ArticleResultsDTO(results: articleDTOs)
        
        // Act
        let result = try await repository.fetchMostViewedArticles(for: .oneDay)
        
        // Assert
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
        // Arrange
        let mockDatasource = MockArticleRemoteDatasource()
        let repository = DefaultArticleRepository(datasource: mockDatasource)
        
        let expectedError = TestMocks.createMockNetworkError()
        mockDatasource.mockError = expectedError
        
        // Act
        do {
            _ = try await repository.fetchMostViewedArticles(for: .oneDay)
            Issue.record("Expected error to be thrown")
        } catch {
            // Assert
            #expect((error as NSError).code == expectedError.code)
            #expect((error as NSError).domain == expectedError.domain)
        }
    }
    
    @Test("Propagates network errors correctly")
    func testFetchMostViewedArticlesNetworkError() async throws {
        // Arrange
        let mockDatasource = MockArticleRemoteDatasource()
        let repository = DefaultArticleRepository(datasource: mockDatasource)
        
        struct NetworkError: Error {
            let message: String
        }
        
        let networkError = NetworkError(message: "Connection failed")
        mockDatasource.mockError = networkError
        
        // Act
        do {
            _ = try await repository.fetchMostViewedArticles(for: .week)
            Issue.record("Expected error to be thrown")
        } catch let error as NetworkError {
            // Assert
            #expect(error.message == "Connection failed")
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}


