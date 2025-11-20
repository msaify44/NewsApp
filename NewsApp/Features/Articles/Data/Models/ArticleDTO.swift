//
//  ArticleDTO.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

struct ArticleDTO: Decodable {
    let id: Int
    let title: String
    let abstract: String
    let publishedDate: String
    let byline: String?
    let media: MediaDTO
    
    enum CodingKeys: String, CodingKey {
        case id, title, abstract, publishedDate = "published_date", byline, media
    }
}

extension ArticleDTO {
    func toDomainModel() -> Article {
        Article(
            id: id,
            title: title,
            abstract: abstract,
            publishedDate: publishedDate,
            thumbnailUrl: media.metadata.first(where: { $0.format == .thumbnail })?.url,
            largeImageUrl: media.metadata.first(where: { $0.format == .medium210 })?.url,
            byLine: byline
        )
    }
}
