//
//  ArticleListCell.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import SwiftUI

struct ArticleListCell: View {
    
    private let article: Article
    static private let imageSize: CGFloat = 50
    
    init(article: Article) {
        self.article = article
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: .md) {
            // Circular image on the left
            if let imageUrl = article.thumbnailUrl {
                AsyncImage(url: URL(string: imageUrl)) { result in
                    result.resizable()
                        .scaledToFill()
                        .frame(width: ArticleListCell.imageSize,
                               height: ArticleListCell.imageSize)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: ArticleListCell.imageSize,
                               height: ArticleListCell.imageSize)
                        .overlay {
                            ProgressView()
                        }
                }
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: ArticleListCell.imageSize,
                           height: ArticleListCell.imageSize)
            }
            
            // Content on the right
            VStack(alignment: .leading, spacing: .sm) {
                // Title/Headline
                Text(article.title)
                    .typography(.body)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                
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
        }
        .padding(.vertical, .sm)
        .padding(.horizontal, .xs)
    }
}

#Preview {
    ArticleListCell(article: .preview)
}
