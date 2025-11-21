//
//  Spacing.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Foundation
import SwiftUI

/// Design system spacing tokens for consistent spacing throughout the app
enum Spacing {
    /// Extra small spacing - 4pt
    case xs
    /// Small spacing - 8pt
    case sm
    /// Medium spacing - 12pt
    case md
    /// Large spacing - 16pt
    case lg
    /// Extra large spacing - 20pt
    case xl
    /// 2X Large spacing - 24pt
    case xxl
    /// 3X Large spacing - 32pt
    case xxxl
    
    /// Returns the CGFloat value for the spacing token
    var value: CGFloat {
        switch self {
        case .xs:
            return 4
        case .sm:
            return 8
        case .md:
            return 12
        case .lg:
            return 16
        case .xl:
            return 20
        case .xxl:
            return 24
        case .xxxl:
            return 32
        }
    }
}

// MARK: - SwiftUI Extensions

extension View {
    /// Applies padding using spacing token
    func padding(_ spacing: Spacing) -> some View {
        self.padding(spacing.value)
    }
    
    /// Applies padding to specific edges using spacing token
    func padding(_ edges: Edge.Set, _ spacing: Spacing) -> some View {
        self.padding(edges, spacing.value)
    }
}

extension VStack {
    /// Creates a VStack with spacing token
    init(alignment: HorizontalAlignment = .center, spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.value, content: content)
    }
}

extension HStack {
    /// Creates an HStack with spacing token
    init(alignment: VerticalAlignment = .center, spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.value, content: content)
    }
}

