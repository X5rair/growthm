//
//  CardView.swift
//  Growth Map
//
//  Created on 2025-11-15.
//

import SwiftUI

/// A reusable card container with "Liquid Glass" visual style
/// Uses ultra thin material for semi-transparent glass effect
struct CardView<Content: View>: View {
    let content: Content
    var padding: CGFloat
    var cornerRadius: CGFloat
    
    init(
        padding: CGFloat = Layout.spacingM,
        cornerRadius: CGFloat = Layout.cornerRadiusM,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(.ultraThinMaterial)
            .cornerRadius(cornerRadius)
            .shadow(
                color: Layout.shadowColor.opacity(Layout.shadowOpacity),
                radius: Layout.shadowRadius,
                y: Layout.shadowY
            )
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: Layout.spacingL) {
            CardView {
                VStack(alignment: .leading, spacing: Layout.spacingS) {
                    Text("Card Title")
                        .font(AppTypography.headline)
                    Text("This is a sample card with glass effect background.")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            CardView(padding: Layout.spacingL, cornerRadius: Layout.cornerRadiusL) {
                Text("Custom Padding & Radius")
                    .font(AppTypography.title3)
            }
        }
        .padding()
    }
}
