//
//  URLDescriptor.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

protocol URLDescriptor {
    var host: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension URLDescriptor {
    
    func buildURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(url: host, resolvingAgainstBaseURL: false)!
        urlComponents.path += path
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = body
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}

