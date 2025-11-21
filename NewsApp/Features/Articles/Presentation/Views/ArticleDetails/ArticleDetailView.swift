//
//  ArticleDetailView.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import SwiftUI

struct ArticleDetailView: View {
    
    let article: Article
    static private let imageHeight: CGFloat = 250
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .md) {

                Group {
                    if let imageUrl = article.largeImageUrl ?? article.thumbnailUrl {
                        AsyncImage(url: URL(string: imageUrl)) { result in
                            result.resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: ArticleDetailView.imageHeight)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: ArticleDetailView.imageHeight)
                                .overlay {
                                    ProgressView()
                                }
                        }
                    } else {
                        // Empty gray container when no image exists
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .frame(height: ArticleDetailView.imageHeight)
                    }
                }
                
                VStack(alignment: .leading, spacing: .md) {
                    Text(article.title)
                        .typography(.h2)
                        .foregroundColor(.primary)
                    
                    // Author and Date row
                    HStack(spacing: .md) {
                        // Author (byline)
                        if let byLine = article.byLine {
                            Text(byLine.uppercased())
                                .typography(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Date with calendar icon
                        HStack(spacing: .xs) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            Text(article.publishedDate)
                                .typography(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, .xs)
                    
                    // Abstract/Description
                    Text(article.abstract)
                        .typography(.body)
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                }
                .padding(.horizontal, .md)
            }
        }
        .navigationTitle("navigation.title.article".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.blue.opacity(1.0), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        ArticleDetailView(article: .preview)
    }
}

