//
//  ArticlesListViewModelTests.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Testing
import Foundation
@testable import NewsApp

@MainActor
struct ArticlesListViewModelTests {
    
    @Test("Initial state is loading")
    func testInitialStateIsLoading() {
        // Arrange & Act
        let sut = makeSUT()
        
        // Assert
        if case .loading = sut.state {
            // success
        } else {
            Issue.record("Expected initial state to be loading")
        }
    }
    
    @Test("Fetch success updates state to loaded")
    func testFetchSuccessUpdatesStateToLoaded() async throws {
        // Arrange
        let mockUseCase = MockFetchMostViewedArticlesUseCase()
        let expectedArticles = TestMocks.createMockArticles()
        mockUseCase.mockResult = expectedArticles
        let sut = makeSUT(useCase: mockUseCase)
        
        // Act
        await sut.fetchMostViewedArticles(period: .week)
        
        // Assert
        if case .loaded(let articles) = sut.state {
            #expect(articles == expectedArticles)
            #expect(mockUseCase.lastRequestedPeriod == .week)
            #expect(mockUseCase.callCount == 1)
        } else {
            Issue.record("Expected state to be loaded but got \(sut.state)")
        }
    }
    
    @Test("Fetch failure updates state to error")
    func testFetchFailureUpdatesStateToError() async {
        // Arrange
        let mockUseCase = MockFetchMostViewedArticlesUseCase()
        let expectedError = TestMocks.createMockNetworkError()
        mockUseCase.mockError = expectedError
        let sut = makeSUT(useCase: mockUseCase)
        
        // Act
        await sut.fetchMostViewedArticles()
        
        // Assert
        if case .error(let message) = sut.state {
            #expect(message == expectedError.localizedDescription)
        } else {
            Issue.record("Expected state to be error but got \(sut.state)")
        }
    }
}

// MARK: - Helpers

private extension ArticlesListViewModelTests {
    func makeSUT(useCase: FetchMostViewedArticlesUseCase = MockFetchMostViewedArticlesUseCase()) -> ArticlesListViewModel {
        ArticlesListViewModel(fetchMostViewedArticlesUseCase: useCase)
    }
}

