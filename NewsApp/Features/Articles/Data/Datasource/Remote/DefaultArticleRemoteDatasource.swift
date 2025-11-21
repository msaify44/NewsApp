//
//  DefaultArticleRemoteDatasource.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

final class DefaultArticleRemoteDatasource: ArticleRemoteDatasource {
    
    private let service: ServiceClient
    private let apiConfig: APIConfig
    
    init(service: ServiceClient, apiConfig: APIConfig = APIConfigFactory.makeConfig()) {
        self.service = service
        self.apiConfig = apiConfig
    }
    
    func fetchMostViewedArticles(for period: Period) async throws -> ArticleResultsDTO {
        let descriptor = FetchMostViewedArticlesURLDescriptor(period: period, apiConfig: apiConfig)
        
        do {
            let result: ArticleResultsDTO = try await service.performRequest(descriptor: descriptor)
            return result
        } catch {
            throw error
        }
    }
}
