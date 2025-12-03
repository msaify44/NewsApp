//
//  DefaultFetchMostViewedArticlesUseCaseTests.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Testing
import Foundation
@testable import NewsApp

// MARK: - DefaultFetchMostViewedArticlesUseCase Tests

struct DefaultFetchMostViewedArticlesUseCaseTests {
    
    // MARK: - Success Cases
    
    @Test("Successfully fetches articles for given period")
    func testFetchMostViewedArticlesSuccess() async throws {
        // Arrange
        let mockRepository = MockArticleRepository()
        let useCase = DefaultFetchMostViewedArticlesUseCase(repository: mockRepository)
        
        let expectedArticles = TestMocks.createMockArticles()
        mockRepository.mockResult = expectedArticles
        
        // Act
        let result = try await useCase.fetchMostViewedArticles(for: .oneDay)
        
        // Assert
        #expect(result.count == expectedArticles.count)
        #expect(result[0].id == expectedArticles[0].id)
        #expect(result[0].title == expectedArticles[0].title)
        #expect(result[0].abstract == expectedArticles[0].abstract)
    }

    
    @Test("Returns articles in correct order")
    func testFetchMostViewedArticlesReturnsCorrectOrder() async throws {
        // Arrange
        let mockRepository = MockArticleRepository()
        let useCase = DefaultFetchMostViewedArticlesUseCase(repository: mockRepository)
        
        let expectedArticles = [
            Article(
                id: 1,
                title: "First Article",
                abstract: "First Abstract",
                publishedDate: "2025-10-01",
                thumbnailUrl: "https://example.com/thumb1.jpg",
                largeImageUrl: "https://example.com/large1.jpg",
                byLine: "First Author"
            ),
            Article(
                id: 2,
                title: "Second Article",
                abstract: "Second Abstract",
                publishedDate: "2025-10-02",
                thumbnailUrl: "https://example.com/thumb2.jpg",
                largeImageUrl: "https://example.com/large2.jpg",
                byLine: "Second Author"
            )
        ]
        
        mockRepository.mockResult = expectedArticles
        
        // Act
        let result = try await useCase.fetchMostViewedArticles(for: .oneDay)
        
        // Assert
        #expect(result.count == 2)
        #expect(result[0].id == 1)
        #expect(result[1].id == 2)
    }
    
    // MARK: - Error Cases
    
    @Test("Propagates repository errors correctly")
    func testFetchMostViewedArticlesPropagatesError() async throws {
        // Arrange
        let mockRepository = MockArticleRepository()
        let useCase = DefaultFetchMostViewedArticlesUseCase(repository: mockRepository)
        
        let expectedError = TestMocks.createMockRepositoryError()
        mockRepository.mockError = expectedError
        
        // Act
        do {
            _ = try await useCase.fetchMostViewedArticles(for: .oneDay)
            Issue.record("Expected error to be thrown")
        } catch {
            // Assert
            #expect((error as NSError).code == expectedError.code)
            #expect((error as NSError).domain == expectedError.domain)
        }
    }
    
    // MARK: - Integration Tests
    
    @Test("Returns same articles as repository")
    func testReturnsSameArticlesAsRepository() async throws {
        // Arrange
        let mockRepository = MockArticleRepository()
        let useCase = DefaultFetchMostViewedArticlesUseCase(repository: mockRepository)
        
        let expectedArticles = TestMocks.createMockArticles()
        mockRepository.mockResult = expectedArticles
        
        // Act
        let result = try await useCase.fetchMostViewedArticles(for: .oneDay)
        
        // Assert
        #expect(result.count == expectedArticles.count)
        for (index, article) in result.enumerated() {
            #expect(article.id == expectedArticles[index].id)
            #expect(article.title == expectedArticles[index].title)
            #expect(article.abstract == expectedArticles[index].abstract)
            #expect(article.publishedDate == expectedArticles[index].publishedDate)
            #expect(article.byLine == expectedArticles[index].byLine)
            #expect(article.thumbnailUrl == expectedArticles[index].thumbnailUrl)
            #expect(article.largeImageUrl == expectedArticles[index].largeImageUrl)
        }
    }
}


