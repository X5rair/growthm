//
//  PrimaryButton.swift
//  Growth Map
//
//  Created on 2025-11-15.
//

import SwiftUI

/// Primary call-to-action button with loading state support
/// Follows Apple HIG minimum touch target guidelines (44pt)
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var height: CGFloat = Layout.buttonHeight
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Layout.spacingS) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.textOnAccent))
                }
                
                Text(title)
                    .font(AppTypography.button)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .foregroundColor(AppColors.textOnAccent)
            .background(isDisabled || isLoading ? AppColors.accent.opacity(0.5) : AppColors.accent)
            .cornerRadius(Layout.cornerRadiusM)
        }
        .disabled(isDisabled || isLoading)
        .accessibilityLabel(title)
        .accessibilityHint(isLoading ? "Loading, please wait" : "Double tap to \(title.lowercased())")
        .accessibilityAddTraits(isLoading ? [.updatesFrequently] : [])
    }
}

#Preview {
    VStack(spacing: Layout.spacingL) {
        PrimaryButton(title: "Sign In", action: {})
        
        PrimaryButton(title: "Loading...", action: {}, isLoading: true)
        
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
        
        PrimaryButton(title: "Compact", action: {}, height: Layout.buttonHeightCompact)
    }
    .padding()
}
