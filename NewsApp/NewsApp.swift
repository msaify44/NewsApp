//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Murtuza Saify on 19/11/2025.
//

import SwiftUI

@main
struct NewsApp: App {
    
    init() {
        DIContainer.shared.assemble()
    }
    
    var body: some Scene {
        return WindowGroup {
            ArticlesListView()
        }
    }
}
