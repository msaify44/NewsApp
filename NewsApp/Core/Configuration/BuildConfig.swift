//
//  BuildConfig.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Foundation

enum BuildConfiguration {
    case debug
    case release
    
    static var current: BuildConfiguration {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
}
