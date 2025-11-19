//
//  EnvironmentKeys.swift
//  NewsApp
//
//  Created by Murtuza Saify on 19/11/2025.
//

import SwiftUI

private struct DIContainerKey: EnvironmentKey {
    static let defaultValue: DIContainer = DIAssembly.build()
}

extension EnvironmentValues {
    var appContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
