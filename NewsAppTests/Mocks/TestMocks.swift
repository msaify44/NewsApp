//
//  TestMocks.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Foundation
@testable import NewsApp

// MARK: - Mock Classes

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

final class MockArticleRepository: ArticleRepository {
    var mockResult: [Article]?
    var mockError: Error?
    
    func fetchMostViewedArticles(for period: Period) async throws -> [Article] {
        if let error = mockError {
            throw error
        }
        
        guard let result = mockResult else {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock result set"])
        }
        
        return result
    }
}

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

final class MockFetchMostViewedArticlesUseCase: FetchMostViewedArticlesUseCase {
    var mockResult: [Article] = TestMocks.createMockArticles()
    var mockError: Error?
    var callCount: Int = 0
    var lastRequestedPeriod: Period?
    
    func fetchMostViewedArticles(for period: Period) async throws -> [Article] {
        callCount += 1
        lastRequestedPeriod = period
        
        if let error = mockError {
            throw error
        }
        
        return mockResult
    }
}

// MARK: - Mock Data Factories

enum TestMocks {
    
    // MARK: - Article Mocks
    
    static func createMockArticles() -> [Article] {
        [
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
    }
    
    static func createMockArticle() -> Article {
        Article(
            id: 1,
            title: "First Article",
            abstract: "First Abstract",
            publishedDate: "2025-10-01",
            thumbnailUrl: "https://example.com/thumb1.jpg",
            largeImageUrl: "https://example.com/large1.jpg",
            byLine: "First Author"
        )
    }
    
    // MARK: - ArticleDTO Mocks
    
    static func createMockArticleDTOs() -> [ArticleDTO] {
        [
            ArticleDTO(
                id: 1,
                title: "First Article",
                abstract: "First Abstract",
                publishedDate: "2025-10-01",
                byline: "First Author",
                media: [
                    MediaDTO(metadata: [
                        MediaMetadataDTO(url: "https://example.com/thumb1.jpg", format: .thumbnail),
                        MediaMetadataDTO(url: "https://example.com/large1.jpg", format: .medium440)
                    ])
                ]
            ),
            ArticleDTO(
                id: 2,
                title: "Second Article",
                abstract: "Second Abstract",
                publishedDate: "2025-10-02",
                byline: "Second Author",
                media: [
                    MediaDTO(metadata: [
                        MediaMetadataDTO(url: "https://example.com/thumb2.jpg", format: .thumbnail),
                        MediaMetadataDTO(url: "https://example.com/large2.jpg", format: .medium440)
                    ])
                ]
            )
        ]
    }
    
    static func createMockArticleDTO() -> ArticleDTO {
        ArticleDTO(
            id: 1,
            title: "First Article",
            abstract: "First Abstract",
            publishedDate: "2025-10-01",
            byline: "First Author",
            media: [
                MediaDTO(metadata: [
                    MediaMetadataDTO(url: "https://example.com/thumb1.jpg", format: .thumbnail),
                    MediaMetadataDTO(url: "https://example.com/large1.jpg", format: .medium440)
                ])
            ]
        )
    }
    
    // MARK: - ArticleResultsDTO Mocks
    
    static func createMockArticleResultsDTO() -> ArticleResultsDTO {
        ArticleResultsDTO(results: createMockArticleDTOs())
    }
    
    // MARK: - Error Mocks
    
    static func createMockNetworkError() -> NSError {
        NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
    }
    
    static func createMockRepositoryError() -> NSError {
        NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Repository error"])
    }
    
    static func createMockTransportError() -> URLError {
        URLError(.notConnectedToInternet)
    }
}
