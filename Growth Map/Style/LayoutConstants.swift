//
//  LayoutConstants.swift
//  Growth Map
//
//  Created on 2025-11-15.
//

import SwiftUI

/// Centralized layout constants for the GrowthMap design system
/// Follows Apple Human Interface Guidelines
struct Layout {
    // MARK: - Spacing
    
    /// Extra small spacing (4pt)
    static let spacingXS: CGFloat = 4
    
    /// Small spacing (8pt)
    static let spacingS: CGFloat = 8
    
    /// Medium spacing (16pt) - default for most layouts
    static let spacingM: CGFloat = 16
    
    /// Large spacing (24pt)
    static let spacingL: CGFloat = 24
    
    /// Extra large spacing (32pt)
    static let spacingXL: CGFloat = 32
    
    /// Extra extra large spacing (48pt)
    static let spacingXXL: CGFloat = 48
    
    // MARK: - Corner Radius
    
    /// Small corner radius for compact elements
    static let cornerRadiusS: CGFloat = 8
    
    /// Medium corner radius for cards and buttons
    static let cornerRadiusM: CGFloat = 12
    
    /// Large corner radius for prominent elements
    static let cornerRadiusL: CGFloat = 16
    
    /// Extra large corner radius for sheets and modals
    static let cornerRadiusXL: CGFloat = 24
    
    // MARK: - Touch Targets
    
    /// Minimum touch target size per Apple HIG (44pt × 44pt)
    static let minTouchTarget: CGFloat = 44
    
    /// Comfortable touch target for primary actions (50pt)
    static let touchTargetComfortable: CGFloat = 50
    
    // MARK: - Component Sizes
    
    /// Standard button height
    static let buttonHeight: CGFloat = 50
    
    /// Compact button height
    static let buttonHeightCompact: CGFloat = 44
    
    /// Text field height
    static let textFieldHeight: CGFloat = 50
    
    /// Icon size small
    static let iconSizeS: CGFloat = 20
    
    /// Icon size medium
    static let iconSizeM: CGFloat = 24
    
    /// Icon size large
    static let iconSizeL: CGFloat = 32
    
    // MARK: - Shadow
    
    /// Shadow radius for elevated cards
    static let shadowRadius: CGFloat = 8
    
    /// Shadow vertical offset
    static let shadowY: CGFloat = 4
    
    /// Shadow opacity for light mode
    static let shadowOpacity: Double = 0.1
    
    /// Shadow color
    static let shadowColor = Color.black
    
    // MARK: - Borders
    
    /// Standard border width
    static let borderWidth: CGFloat = 1
    
    /// Thick border width for emphasis
    static let borderWidthThick: CGFloat = 2
    
    // MARK: - Screen Padding
    
    /// Standard horizontal screen padding
    static let screenPadding: CGFloat = 20
    
    /// Compact screen padding for narrow layouts
    static let screenPaddingCompact: CGFloat = 16
}

// MARK: - View Modifiers

extension View {
    /// Apply standard card styling with glass effect
    func cardStyle() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(Layout.cornerRadiusM)
            .shadow(
                color: Layout.shadowColor.opacity(Layout.shadowOpacity),
                radius: Layout.shadowRadius,
                y: Layout.shadowY
            )
    }
    
    /// Apply standard screen padding
    func screenPadding() -> some View {
        self.padding(.horizontal, Layout.screenPadding)
    }
}
