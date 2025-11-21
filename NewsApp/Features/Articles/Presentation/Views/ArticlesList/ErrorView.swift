//
//  ErrorView.swift
//  NewsApp
//
//  Created by Murtuza Saify on 21/11/2025.
//

import SwiftUI

struct ErrorView: View {
    
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: .lg) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            VStack(spacing: .sm) {
                Text("error.title".localized)
                    .typography(.h3)
                    .foregroundColor(.primary)
                
                Text("error.description".localized)
                    .typography(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .md)
            }
            
            // Retry button
            Button(action: onRetry) {
                HStack(spacing: .sm) {
                    Image(systemName: "arrow.clockwise")
                    Text("error.button.retry".localized)
                }
                .typography(.bodyBold)
                .foregroundColor(.white)
                .padding(.horizontal, .xl)
                .padding(.vertical, .md)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .padding(.top, .md)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.md)
    }
}

#Preview {
    ErrorView() {}
}

