//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Murtuza Saify on 19/11/2025.
//

import SwiftUI

@main
struct NewsApp: App {
    var body: some Scene {
        
        let diContainer = DIContainer.shared
        diContainer.assemble()
        
        return WindowGroup {
            ArticlesListView()
        }
    }
}
