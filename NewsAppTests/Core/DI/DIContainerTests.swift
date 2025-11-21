//
//  DIContainerTests.swift
//  NewsAppTests
//
//  Created by Murtuza Saify on 19/11/2025.
//

import Testing
import Foundation
@testable import NewsApp

// MARK: - DIContainer Tests
struct DIContainerTests {
    
    // MARK: - Factory Registration Tests
    
    @Test("Factory registration creates new instance on each resolution")
    func testFactoryRegistrationCreatesNewInstances() {
        // Arrange
        let container = DIContainer()
        
        container.register(TestService.self) { _ in
            TestServiceImpl()
        }
        
        // Act
        let first = container.resolve(TestService.self)
        let second = container.resolve(TestService.self)
        
        // Assert
        #expect(first.id != second.id, "Factory should create new instances")
    }
    
    @Test("Factory can resolve dependencies")
    func testFactoryCanResolveDependencies() {
        // Arrange
        let container = DIContainer()
        
        container.register(TestRepository.self) { _ in
            TestRepositoryImpl(name: "TestRepo")
        }
        
        container.register(TestService.self) { container in
            let repository = container.resolve(TestRepository.self)
            return TestDependentService(repository: repository)
        }
        
        // Act
        let service = container.resolve(TestService.self) as? TestDependentService
        
        // Assert
        #expect(service != nil)
        #expect(service?.repository.name == "TestRepo")
    }
    
    // MARK: - Singleton Registration Tests
    
    @Test("Singleton registration returns same instance")
    func testSingletonReturnsSameInstance() {
        // Arrange
        let container = DIContainer()
        
        container.registerSingleton(TestService.self) { _ in
            TestServiceImpl()
        }
        
        // Act
        let first = container.resolve(TestService.self)
        let second = container.resolve(TestService.self)
        
        // Assert
        #expect(first.id == second.id, "Singleton should return same instance")
    }
    
    
    // MARK: - Optional Resolution Tests
    
    @Test("resolveOptional returns nil for unregistered type")
    func testResolveOptionalReturnsNilForUnregisteredType() {
        // Arrange
        let container = DIContainer()
        
        // Act
        let result = container.resolveOptional(TestService.self)
        
        // Assert
        #expect(result == nil)
    }
    
    @Test("resolveOptional returns value for registered type")
    func testResolveOptionalReturnsValueForRegisteredType() {
        // Arrange
        let container = DIContainer()
        
        container.register(TestService.self) { _ in
            TestServiceImpl(id: "TestID")
        }
        
        // Act
        let result = container.resolveOptional(TestService.self)
        
        // Assert
        #expect(result != nil)
        #expect(result?.id == "TestID")
    }
    
    // MARK: - Mandatory Resolution Tests
    
    @Test("resolve returns value for registered type")
    func testResolveReturnsValueForRegisteredType() {
        // Arrange
        let container = DIContainer()
        
        container.register(TestService.self) { _ in
            TestServiceImpl(id: "ResolvedID")
        }
        
        // Act
        let result = container.resolve(TestService.self)
        
        // Assert
        #expect(result.id == "ResolvedID")
    }
    
    // MARK: - Removing All Tests
    
    @Test("removingAll clears all registrations")
    func testRemovingAllClearsRegistrations() {
        // Arrange
        let container = DIContainer()
        
        container.register(TestService.self) { _ in
            TestServiceImpl()
        }
        
        // Act
        _ = container.removingAll()
        
        // Assert
        let result = container.resolveOptional(TestService.self)
        
        #expect(result == nil)
    }
}

// MARK: - Test Dependencies

protocol TestService {
    var id: String { get }
}

protocol TestRepository {
    var name: String { get }
}

final class TestServiceImpl: TestService {
    let id: String
    
    init(id: String = UUID().uuidString) {
        self.id = id
    }
}

final class TestRepositoryImpl: TestRepository {
    let name: String
    
    init(name: String = "DefaultRepository") {
        self.name = name
    }
}

final class TestDependentService: TestService {
    let id: String
    let repository: TestRepository
    
    init(id: String = UUID().uuidString, repository: TestRepository) {
        self.id = id
        self.repository = repository
    }
}
