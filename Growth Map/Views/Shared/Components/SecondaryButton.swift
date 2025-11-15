//
//  SecondaryButton.swift
//  Growth Map
//
//  Created on 2025-11-15.
//

import SwiftUI

/// Secondary action button with outline style
/// Used for less prominent actions alongside primary buttons
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    var height: CGFloat = Layout.buttonHeight
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.button)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .foregroundColor(isDisabled ? AppColors.textSecondary : AppColors.accent)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cornerRadiusM)
                        .stroke(isDisabled ? AppColors.textSecondary : AppColors.accent, lineWidth: Layout.borderWidthThick)
                )
        }
        .disabled(isDisabled)
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to \(title.lowercased())")
    }
}

#Preview {
    VStack(spacing: Layout.spacingL) {
        SecondaryButton(title: "Cancel", action: {})
        
        SecondaryButton(title: "Disabled", action: {}, isDisabled: true)
        
        SecondaryButton(title: "Compact", action: {}, height: Layout.buttonHeightCompact)
    }
    .padding()
}
