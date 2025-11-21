//
//  LocalizedStringKey+Extension.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import SwiftUI

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

