//
//  ArticleRepository.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

protocol ArticleRepository {
    func fetchMostViewedArticles(for period: Period) async throws -> [Article]
}
