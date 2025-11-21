//
//  DIContainer+Assembly.swift
//  NewsApp
//
//  Created by Murtuza Saify on 19/11/2025.
//

import Foundation

extension DIContainer {
    func assemble()  {
        self.register( FetchMostViewedArticlesUseCase.self) { container in
            return DefaultFetchMostViewedArticlesUseCase(repository: container.resolve(ArticleRepository.self))
        }
        
        self.register( ArticleRepository.self) { container in
            return DefaultArticleRepository(datasource: container.resolve(ArticleRemoteDatasource.self))
        }
        
        self.register( ArticleRemoteDatasource.self) { container in
            return DefaultArticleRemoteDatasource(service: container.resolve(ServiceClient.self))
        }
        
        self.register( ServiceClient.self) { _ in
            return DefaultServiceClient()
        }
        
        self.register( ArticlesListViewModel.self) { container in
            return ArticlesListViewModel(fetchMostViewedArticlesUseCase: container.resolve(FetchMostViewedArticlesUseCase.self))
        }
    }
}
