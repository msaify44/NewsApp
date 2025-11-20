//
//  DefaultArticleRemoteDatasource.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

final class DefaultArticleRemoteDatasource: ArticleRemoteDatasource {
    
    private let service: ServiceClient
    
    init(service: ServiceClient) {
        self.service = service
    }
    
    func fetchMostViewedArticles(for period: Period) async throws -> ArticleResultsDTO {
        let descriptor = FetchMostViewedArticlesURLDescriptor(period: period)
        
        do {
            let result: ArticleResultsDTO = try await service.performRequest(descriptor: descriptor)
            return result
        } catch {
            throw error
        }
    }
}
