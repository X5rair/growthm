//
//  LoadingView.swift
//  Growth Map
//
//  Created on 2025-11-15.
//

import SwiftUI

/// Full-screen loading overlay with glass effect
struct LoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: Layout.spacingM) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.accent))
                    .scaleEffect(1.5)
                
                Text(message)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textPrimary)
            }
            .padding(Layout.spacingXL)
            .background(.ultraThinMaterial)
            .cornerRadius(Layout.cornerRadiusL)
            .shadow(
                color: Layout.shadowColor.opacity(0.2),
                radius: Layout.shadowRadius * 2,
                y: Layout.shadowY * 2
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
        .accessibilityAddTraits(.updatesFrequently)
    }
}

#Preview {
    LoadingView()
}

#Preview("Custom Message") {
    LoadingView(message: "Signing in...")
}
