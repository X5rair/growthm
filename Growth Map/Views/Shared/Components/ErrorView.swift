//
//  ErrorView.swift
//  Growth Map
//
//  Created on 2025-11-15.
//

import SwiftUI

/// Reusable error message display with dismiss action
struct ErrorView: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: Layout.spacingM) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(AppColors.error)
                .font(.title3)
            
            Text(message)
                .font(AppTypography.callout)
                .foregroundColor(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(AppColors.textSecondary)
                    .font(.title3)
                    .frame(width: Layout.minTouchTarget, height: Layout.minTouchTarget)
            }
            .accessibilityLabel("Dismiss error")
        }
        .padding(Layout.spacingM)
        .background(AppColors.error.opacity(0.1))
        .cornerRadius(Layout.cornerRadiusM)
        .overlay(
            RoundedRectangle(cornerRadius: Layout.cornerRadiusM)
                .stroke(AppColors.error.opacity(0.3), lineWidth: Layout.borderWidth)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error: \(message)")
        .accessibilityHint("Double tap the close button to dismiss")
    }
}

#Preview {
    VStack(spacing: Layout.spacingL) {
        ErrorView(
            message: "Invalid email or password",
            onDismiss: {}
        )
        
        ErrorView(
            message: "Network connection failed. Please check your internet connection and try again.",
            onDismiss: {}
        )
    }
    .padding()
}
