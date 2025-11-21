//
//  ArticlesListLoadedView.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import SwiftUI

struct ArticlesListLoadedView: View {
    
    private let articles: [Article]
    
    init(articles: [Article]) {
        self.articles = articles
    }
    
    var body: some View {
        List {
            ForEach(articles, id: \.id) { item in
                NavigationLink(value: item) {
                    ArticleListCell(article: item)
                }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Article.self) { article in
            ArticleDetailView(article: article)
        }
    }
}

#Preview {
    ArticlesListLoadedView(articles: Article.previews)
}
