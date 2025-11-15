//
//  AuthenticationView.swift
//  Growth Map
//
//  Created on 2025-11-15.
//

import SwiftUI

/// Root authentication view that coordinates between Sign In and Sign Up
struct AuthenticationView: View {
    @StateObject var viewModel: AuthenticationViewModel
    
    init(supabaseService: SupabaseService) {
        _viewModel = StateObject(wrappedValue: AuthenticationViewModel(supabaseService: supabaseService))
    }
    
    var body: some View {
        ZStack {
            // Background gradient for liquid glass effect
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.3),
                    Color.cyan.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Mode Selector
                Picker("Authentication Mode", selection: $viewModel.currentMode) {
                    ForEach(AuthenticationViewModel.AuthMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, Layout.spacingL)
                .padding(.bottom, Layout.spacingM)
                
                // Content
                TabView(selection: $viewModel.currentMode) {
                    SignInView(viewModel: viewModel.signInViewModel)
                        .tag(AuthenticationViewModel.AuthMode.signIn)
                    
                    SignUpView(viewModel: viewModel.signUpViewModel)
                        .tag(AuthenticationViewModel.AuthMode.signUp)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .animation(.easeInOut, value: viewModel.currentMode)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var supabaseService: SupabaseService
        
        init() {
            let service = try! SupabaseService()
            _supabaseService = StateObject(wrappedValue: service)
        }
        
        var body: some View {
            AuthenticationView(supabaseService: supabaseService)
        }
    }
    
    return PreviewWrapper()
}
