//
//  FetchMostViewedArticlesUseCase.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

protocol FetchMostViewedArticlesUseCase {
    func fetchMostViewedArticles(for period: Period) async throws -> [Article]
}

final class DefaultFetchMostViewedArticlesUseCase: FetchMostViewedArticlesUseCase {
    private let repository: ArticleRepository
    
    init(repository: ArticleRepository) {
        self.repository = repository
    }
    
    func fetchMostViewedArticles(for period: Period) async throws -> [Article] {
        return try await repository.fetchMostViewedArticles(for: period)
    }
}
