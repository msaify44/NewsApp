//
//  DIContainer.swift
//  NewsApp
//
//  Created by Murtuza Saify on 19/11/2025.
//

import Foundation

// MARK: - Registry Container

protocol DIContainer: AnyObject {
    // Registration
    func register<T>(_ type: T.Type, factory: @escaping (DIContainer) -> T)
    func registerSingleton<T>(_ type: T.Type, factory: @escaping (DIContainer) -> T)

    // Resolution
    func resolve<T>(_ type: T.Type) -> T
    func resolveOptional<T>(_ type: T.Type) -> T?

    // Utilities
    func removingAll() -> Self
}

final class DefaultDIContainer: DIContainer {
    private enum Scope {
        case factory((DIContainer) -> Any)
        case singleton(make: (DIContainer) -> Any, cached: Any?)
    }

    private var registry: [ObjectIdentifier: Scope] = [:]
    private let lock = NSRecursiveLock()

    init() {}

    // MARK: Registration

    func register<T>(_ type: T.Type, factory: @escaping (DIContainer) -> T) {
        let key = ObjectIdentifier(type)
        lock.lock(); defer { lock.unlock() }
        registry[key] = .factory({ container in factory(container) })
    }

    func registerSingleton<T>(_ type: T.Type, factory: @escaping (DIContainer) -> T) {
        let key = ObjectIdentifier(type)
        lock.lock(); defer { lock.unlock() }
        registry[key] = .singleton(make: { container in factory(container) }, cached: nil)
    }

    // MARK: Resolution

    func resolve<T>(_ type: T.Type = T.self) -> T {
        guard let value: T = resolveOptional(type) else {
            fatalError("No registration for type \(type)")
        }
        return value
    }

    func resolveOptional<T>(_ type: T.Type = T.self) -> T? {
        let key = ObjectIdentifier(type)
        lock.lock(); defer { lock.unlock() }

        guard let scope = registry[key] else { return nil }

        switch scope {
        case .factory(let make):
            return make(self) as? T

        case .singleton(let make, let cached):
            if let cached = cached as? T {
                return cached
            } else {
                let instance = make(self)
                registry[key] = .singleton(make: make, cached: instance)
                return instance as? T
            }
        }
    }

    // MARK: Utilities

    func removingAll() -> Self {
        lock.lock(); defer { lock.unlock() }
        registry.removeAll()
        return self
    }
}
