//
//  MostViewArticlesURLDescriptor.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

struct FetchMostViewedArticlesURLDescriptor: URLDescriptor {
    
    private let period: Period
    private let apiConfig: APIConfig
    
    init(period: Period,
         apiConfig: APIConfig = DefaultAPIConfig()) {
        self.period = period
        self.apiConfig = apiConfig
    }
    
    var host: URL { apiConfig.baseURL }
    
    var path: String { "/svc/mostpopular/v2/mostviewed/all-sections/\(period.rawValue).json" }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String] { [:] }
    
    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "api-key", value: apiConfig.apiKey)]
    }
}
