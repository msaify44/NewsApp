//
//  ArticleRemoteDatasource.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

protocol ArticleRemoteDatasource {
    func fetchMostViewedArticles(for period: Period) async throws -> ArticleResultsDTO
}
