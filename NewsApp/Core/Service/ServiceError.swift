//
//  ServiceError.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

enum ServiceError: Error {
    case transport(Error)                 // URLSession/connection-level errors
    case httpStatus(code: Int, data: Data?) // Non-2xx HTTP responses
    case decoding(Error)                  // JSON decoding failures
}

