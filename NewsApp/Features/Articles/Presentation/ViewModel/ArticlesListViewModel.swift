//
//  ArticlesListingViewModel.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Foundation
import Combine

@MainActor
final class ArticlesListViewModel: ObservableObject {
    
    enum State {
        case loading
        case loaded([Article])
        case error(String)
    }
    
    @Published var state: State = .loading
    private let fetchMostViewedArticlesUseCase: FetchMostViewedArticlesUseCase
    
    init(fetchMostViewedArticlesUseCase: FetchMostViewedArticlesUseCase) {
        self.fetchMostViewedArticlesUseCase = fetchMostViewedArticlesUseCase
    }
    
    func fetchMostViewedArticles(period: Period = .week) async {
        state = .loading
        do {
            let articles = try await fetchMostViewedArticlesUseCase.fetchMostViewedArticles(for: period)
            state = .loaded(articles)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

