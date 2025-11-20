//
//  DefaultServiceClientTests.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Testing
import Foundation
@testable import NewsApp

// MARK: - DefaultServiceClient Tests

struct DefaultServiceClientTests {
    
    private func createClientWithMockSession() -> DefaultServiceClient {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return DefaultServiceClient(session: session)
    }
    
    private func resetMockURLProtocol() {
        MockURLProtocol.requestHandler = nil
    }
    
    @Test("Successful request with JSON decoding")
    func testSuccessfulRequestWithJSONDecoding() async throws {
        resetMockURLProtocol()
        defer { resetMockURLProtocol() }
        
        let expectedResponse = TestResponse(id: 1, name: "Test")
        let responseData = try JSONEncoder().encode(expectedResponse)
        
        // Set handler BEFORE creating client to ensure it's captured
        let handler: (URLRequest) throws -> (HTTPURLResponse, Data) = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, responseData)
        }
        
        MockURLProtocol.requestHandler = handler
        
        let client = createClientWithMockSession()
        let descriptor = TestRequestDescriptor(
            host: URL(string: "https://api.example.com")!,
            path: "/test"
        )
        
        let result: TestResponse = try await client.performRequest(descriptor: descriptor)
        
        #expect(result == expectedResponse)
    }
}

// MARK: - Mock URLProtocol

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "MockURLProtocol", code: -1, userInfo: [NSLocalizedDescriptionKey: "No request handler set"]))
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No-op
    }
}

// MARK: - Test Request Descriptor

struct TestRequestDescriptor: URLDescriptor {
    var host: URL
    let path: String
    let headers: [String: String]
    let method: HTTPMethod
    let body: Data?
    let queryItems: [URLQueryItem]?
    
    init(
        host: URL = URL(string: "https://api.example.com")!,
        path: String = "/test",
        headers: [String: String] = [:],
        method: HTTPMethod = .get,
        body: Data? = nil,
        queryItems: [URLQueryItem]? = nil
    ) {
        self.host = host
        self.path = path
        self.headers = headers
        self.method = method
        self.body = body
        self.queryItems = queryItems
    }
}

// MARK: - Test Models

struct TestResponse: Codable, Equatable {
    let id: Int
    let name: String
}

struct TestDecodable: Codable, Equatable {
    let value: String
}

class MockURLSessionProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override
    func stopLoading() {
        
    }
    
    override
    class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override
    class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override
    func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError()
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
