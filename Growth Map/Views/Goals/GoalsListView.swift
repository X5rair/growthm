//
//  GoalsListView.swift
//  Growth Map
//
//  Created on 2025-11-16.
//

import SwiftUI

struct GoalsListView: View {
    @EnvironmentObject private var supabaseService: SupabaseService
    @EnvironmentObject private var growthMapAPI: GrowthMapAPI

    @State private var goals: [Goal] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var hasLoaded = false

    var body: some View {
        List {
            if let errorMessage {
                Section {
                    ErrorView(message: errorMessage) {
                        self.errorMessage = nil
                    }
                }
                .listRowBackground(Color.clear)
                .textCase(nil)
            }

            if goals.isEmpty && !isLoading {
                Section(header: Text("No Goals Yet").font(AppTypography.title3)) {
                    Text("Create a growth map to see your AI-generated skill tree here.")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, Layout.spacingL)
                }
                .listRowBackground(Color.clear)
                .textCase(nil)
            } else {
                Section(header: Text("Your Goals").font(AppTypography.title3)) {
                    ForEach(goals) { goal in
                        NavigationLink {
                            SkillTreeView(goalId: goal.id, initialGoal: goal, growthMapAPI: growthMapAPI)
                        } label: {
                            goalRow(goal)
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(
                            EdgeInsets(top: Layout.spacingS, leading: 0, bottom: Layout.spacingS, trailing: 0)
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .textCase(nil)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppColors.background)
        .navigationTitle("Goals")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task { try? await supabaseService.signOut() }
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(AppColors.accent)
                }
                .accessibilityLabel("Sign out")
            }
        }
        .overlay {
            if isLoading && goals.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.accent))
            }
        }
        .task {
            await loadGoals(force: false)
        }
        .refreshable {
            await loadGoals(force: true)
        }
    }

    private func goalRow(_ goal: Goal) -> some View {
        CardView {
            VStack(alignment: .leading, spacing: Layout.spacingS) {
                Text(goal.title)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)

                Text(goal.description)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)

                HStack(spacing: Layout.spacingM) {
                    Label("Priority \(goal.priority)", systemImage: "flag.fill")
                    Label("\(goal.dailyMinutes) min/day", systemImage: "timer")
                }
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
            }
        }
    }

    @MainActor
    private func loadGoals(force: Bool) async {
        guard !isLoading else { return }
        if !force && hasLoaded { return }

        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            goals = try await supabaseService.fetchGoals()
            hasLoaded = true
        } catch {
            if let supabaseError = error as? SupabaseError {
                errorMessage = supabaseError.errorDescription ?? "Unable to load goals."
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}
