//
//  DefaultArticleRepository.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

final class DefaultArticleRepository: ArticleRepository {
    
    private let datasource: ArticleRemoteDatasource
    
    init(datasource: ArticleRemoteDatasource) {
        self.datasource = datasource
    }
    
    func fetchMostViewedArticles(for period: Period) async throws -> [Article] {
        do {
            let result = try await datasource.fetchMostViewedArticles(for: period)
            return result.results.map { $0.toDomainModel() }
        } catch {
            throw error
        }
    }
}
