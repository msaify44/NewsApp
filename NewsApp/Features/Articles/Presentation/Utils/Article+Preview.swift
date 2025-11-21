//
//  Article+Preview.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Foundation

extension Article {
    static var preview: Article {
        Article(
            id: 1,
            title: "Supporters of the Democratic candidate Jon Ossoff after his victory in Georgia",
            abstract: "This is a detailed abstract of the article that provides more information about the content and context of the news story. It contains multiple sentences to demonstrate how longer content is displayed in the UI.",
            publishedDate: "2017-06-23",
            thumbnailUrl: "https://via.placeholder.com/150",
            largeImageUrl: "https://via.placeholder.com/800x400",
            byLine: "By DAVID LEONHARDT and STUART A. THOMPSON"
        )
    }
    
    static var previews: [Article] {
        [
            Article(
                id: 1,
                title: "Supporters of the Democratic candidate Jon Ossoff after his victory in Georgia",
                abstract: "This is a detailed abstract of the article that provides more information about the content and context of the news story.",
                publishedDate: "2017-06-23",
                thumbnailUrl: "https://via.placeholder.com/150",
                largeImageUrl: "https://via.placeholder.com/800x400",
                byLine: "By DAVID LEONHARDT and STUART A. THOMPSON"
            ),
            Article(
                id: 2,
                title: "Breaking News: Major Development in Technology Sector",
                abstract: "A comprehensive overview of recent technological advancements and their impact on various industries.",
                publishedDate: "2025-11-20",
                thumbnailUrl: "https://via.placeholder.com/150",
                largeImageUrl: nil,
                byLine: "By JANE SMITH"
            ),
            Article(
                id: 3,
                title: "Economic Trends Show Positive Growth",
                abstract: "Analysis of current economic indicators reveals promising trends for the upcoming quarter.",
                publishedDate: "2025-11-19",
                thumbnailUrl: nil,
                largeImageUrl: nil,
                byLine: nil
            )
        ]
    }
}

