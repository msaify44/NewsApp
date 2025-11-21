//
//  ArticlesListView.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import SwiftUI

struct ArticlesListView: View {
    
    @StateObject var viewModel: ArticlesListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.resolve(ArticlesListViewModel.self))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .loaded(let array):
                    ArticlesListLoadedView(articles: array)
                case .error:
                    ErrorView() {
                        Task {
                            await viewModel.fetchMostViewedArticles()
                        }
                    }
                }
            }
            .navigationTitle("navigation.title.most_popular".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.blue.opacity(1.0), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            Task {
                await viewModel.fetchMostViewedArticles()
            }
        }
    }
}
