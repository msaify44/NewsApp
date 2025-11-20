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

struct DefaultAPIConfig: APIConfig {
    var baseURL: URL { URL(string: "https://api.nytimes.com")! }
    var apiKey: String { "uBzMdN85lv7Zrodln5qnqoi40JUcxQTi" }
}
