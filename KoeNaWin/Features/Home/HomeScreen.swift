//
//  HomeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import Charts
import Combine
import SwiftUI

struct HomeScreen: View {
    @Binding var path: NavigationPath
    @EnvironmentObject private var configManager: ConfigManager
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            if case .active = vm.status {
                ScrollView {
                    VStack(spacing: 25) {
                        vegetarianSection

                        todayMantra

                        currentStageCompletion

                        completionSection
                    }
                    .padding()
                }
            } else {
                NoticeCard(status: vm.status)
            }
        }
        .navigationTitle("homeScreen-navTitle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension HomeScreen {
    var completionSection: some View {
        VStack {
            Text("homeScreen-completionSection-progress")
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                ZStack {
                    // Background circle (remaining days)
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 24)
                        .frame(width: 120, height: 120)

                    // Progress circle (completed days)
                    Circle()
                        .trim(from: 0, to: max(0.02, CGFloat(vm.totalDay) / 81.0 - 0.08))
                        .stroke(.accent, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))

                    // Center text
                    Text("\(vm.totalDay) / 81")
                        .font(.headline)
                }
                .padding()

                VStack(spacing: 20) {
                    Text("\(String(format: "%.1f", vm.totalProgressPercentage)) %")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule(style: .circular)
                                .fill(.accent)
                        )
                    HStack {
                        Image(systemName: "staroflife.fill")
                            .font(.caption2)

                        Text("homeScreen-completionSection-day-left-\(81 - vm.totalDay)")
                            .lineLimit(1, reservesSpace: true)
                    }
                }
            }
        }
        .padding()
        .listSectionBackground
    }

    var currentStageCompletion: some View {
        VStack {
            Text("addhithan-stage-\(vm.stage)")
                .font(.title2)
                .fontWeight(.bold)

            ProgressView(value: Double(vm.day), total: 9) {} currentValueLabel: {
                HStack {
                    Text("\(String(format: "%.1f", vm.currentProgressPercentage)) %")
                    Spacer()
                    Text("homeScreen-currentStageCompletion-day-\(vm.day)")
                }
                .font(.subheadline)
            }
            .progressViewStyle(CustomProgressViewStyle(height: 20))
        }
        .padding()
        .listSectionBackground
        .contentShape(Rectangle())
        .onTapGesture {
            if let currentStage = koeNaWinStages.first(where: { $0.stage == vm.stage }) {
                configManager.selectedTab = .stages
                // Add the current stage to the navigation path
                if path.count > 0 {
                    path.removeLast(path.count)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    path.append(currentStage)
                }
            }
        }
    }

    var todayMantra: some View {
        VStack(spacing: 10) {
            HStack {
                Text("\(vm.currentPrayer?.day.localized(to: currentLanguage) ?? "")")
                Spacer()
                Text("addhithan-stage-\(vm.stage)")
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.accent)

            Text("\(vm.currentPrayer?.mantra ?? "")")
                .font(.title)
                .fontWeight(.bold)

            Text("bead-count-\(vm.currentPrayer?.rounds ?? 0)")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
        .listSectionBackground
        .contentShape(Rectangle())
        .onTapGesture {
            configManager.selectedTab = .practice
        }
    }

    @ViewBuilder
    var vegetarianSection: some View {
        let todayVegetarian = vm.dayUntilVegetarian == 0
        let message: LocalizedStringKey = todayVegetarian ? "homeScreen-vegetarianSection-isVegetarian" : "homeScreen-vegetarianSection-vegetarian-in-\(vm.dayUntilVegetarian)"

        if vm.stage == 9, vm.day > 5 {
            EmptyView()
        } else {
            Text(message)
                .font(.headline)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 10)
                .listSectionBackground
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen(path: .constant(NavigationPath()))
            .previewEnvironment()
    }
}
