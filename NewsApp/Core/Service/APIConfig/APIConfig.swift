//
//  APIConfig.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Foundation

protocol APIConfig {
    var baseURL: URL { get }
    var apiKey: String { get }
}

extension APIConfig {
    
    var apiKey: String {
        guard let apiKey = Bundle.main.string(forInfoDictionaryKey: "API_KEY"),
              !apiKey.isEmpty else {
            fatalError("API_KEY not found or invalid in Info.plist.")
        }
        return apiKey
    }
}

struct DevelopmentAPIConfig: APIConfig {
    var baseURL: URL {
        let fullURL = "https://api.nytimes.com"
        guard let url = URL(string: fullURL) else {
            fatalError("Invalid URL constructed from API_HOST: \(fullURL)")
        }
        return url
    }
}

struct ProductionAPIConfig: APIConfig {
    var baseURL: URL {
        let fullURL = "https://api.nytimes.com"
        guard let url = URL(string: fullURL) else {
            fatalError("Invalid URL constructed from API_HOST: \(fullURL)")
        }
        return url
    }
}

extension Bundle {
    func string(forInfoDictionaryKey key: String) -> String? {
        guard let value = object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty,
              !value.hasPrefix("$(") else {
            return nil
        }
        return value
    }
}
