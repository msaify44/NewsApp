//
//  ServiceClient.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

protocol ServiceClient {
    func performRequest<T: Decodable>(descriptor: URLDescriptor) async throws -> T
}

final class DefaultServiceClient: ServiceClient {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func performRequest<T: Decodable>(descriptor: URLDescriptor) async throws -> T {

        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: descriptor.buildURLRequest())
        } catch {
            throw ServiceError.transport(error)
        }
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw ServiceError.httpStatus(code: httpResponse.statusCode, data: data)
        }
        
        do {
            let result: T = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw ServiceError.decoding(error)
        }
    }
}

