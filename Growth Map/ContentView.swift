//
//  ContentView.swift
//  Growth Map
//
//  Created by Baurzhan Beglerov on 15.11.2025.
//

import SwiftUI

/// Root content view that handles authentication state and routes to appropriate screens
struct ContentView: View {
    @EnvironmentObject var supabaseService: SupabaseService
    @EnvironmentObject var growthMapAPI: GrowthMapAPI

    var body: some View {
        Group {
            if supabaseService.isAuthenticated {
                // Main app view (post-authentication)
                MainTabView()
            } else {
                // Authentication view
                AuthenticationView(supabaseService: supabaseService)
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var supabaseService: SupabaseService
        @StateObject private var growthMapAPI: GrowthMapAPI

        init() {
            let service = try! SupabaseService()
            _supabaseService = StateObject(wrappedValue: service)
            _growthMapAPI = StateObject(wrappedValue: GrowthMapAPI(supabaseService: service))
        }

        var body: some View {
            ContentView()
                .environmentObject(supabaseService)
                .environmentObject(growthMapAPI)
        }
    }

    return PreviewWrapper()
}
