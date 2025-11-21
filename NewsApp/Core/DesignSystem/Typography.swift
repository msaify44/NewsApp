//
//  Typography.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import Foundation
import SwiftUI

enum Typography {
    /// Display text - Large, bold text for main headings (32pt, bold)
    case display
    /// Heading 1 - Largest heading style (28pt, bold)
    case h1
    /// Heading 2 - Second largest heading style (24pt, bold)
    case h2
    /// Heading 3 - Medium heading style (20pt, semibold)
    case h3
    /// Body - Standard body text (16pt, regular)
    case body
    /// Body Bold - Bold body text (16pt, bold)
    case bodyBold
    /// Caption - Small text for captions and labels (14pt, regular)
    case caption
    /// Caption Bold - Bold caption text (14pt, bold)
    case captionBold
    /// Custom sizes for specific use cases
    case custom(size: CGFloat, weight: Font.Weight)
    
    /// Returns the font for the typography token
    var font: Font {
        switch self {
        case .display:
            return .system(size: 32, weight: .bold, design: .default)
        case .h1:
            return .system(size: 28, weight: .bold, design: .default)
        case .h2:
            return .system(size: 24, weight: .bold, design: .default)
        case .h3:
            return .system(size: 20, weight: .semibold, design: .default)
        case .body:
            return .system(size: 16, weight: .regular, design: .default)
        case .bodyBold:
            return .system(size: 16, weight: .bold, design: .default)
        case .caption:
            return .system(size: 14, weight: .regular, design: .default)
        case .captionBold:
            return .system(size: 14, weight: .bold, design: .default)
        case .custom(let size, let weight):
            return .system(size: size, weight: weight, design: .default)
        }
    }
    
    var size: CGFloat {
        switch self {
        case .display:
            return 32
        case .h1:
            return 28
        case .h2:
            return 24
        case .h3:
            return 20
        case .body, .bodyBold:
            return 16
        case .caption, .captionBold:
            return 14
        case .custom(let size, _):
            return size
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .display, .h1, .h2, .bodyBold, .captionBold:
            return .bold
        case .h3:
            return .semibold
        case .body, .caption:
            return .regular
        case .custom(_, let weight):
            return weight
        }
    }
}

// MARK: - SwiftUI Extensions

extension Text {
    func typography(_ typography: Typography) -> some View {
        self.font(typography.font)
    }
}

extension View {
    /// Applies typography token to any view that contains text
    func typography(_ typography: Typography) -> some View {
        self.font(typography.font)
    }
}

