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
        .navigationTitle("ကိုးနဝင်း")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension HomeScreen {
    var completionSection: some View {
        VStack {
            Text("အဓိဌာန်ပြီးမြောက်မှု")
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
                    Text("\(vm.totalDay.toMyanmarDigits()) / ၈၁")
                        .font(.headline)
                }
                .padding()

                VStack(spacing: 20) {
                    Text("\(vm.totalProgressPercentage.toMyanmarDigits()) %")
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

                        Text("\((81 - vm.totalDay).toMyanmarDigits()) ရက်ကျန်သည်")
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
            Text("အဓိဌာန်အဆင့် (\(vm.stage.toMyanmarDigits()))")
                .font(.title2)
                .fontWeight(.bold)

            ProgressView(value: Double(vm.day), total: 9) {} currentValueLabel: {
                HStack {
                    Text("\(vm.currentProgressPercentage.toMyanmarDigits()) %")
                    Spacer()
                    Text("\(vm.day.toMyanmarDigits()) / ၉ ရက်")
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
                Text("\(vm.currentPrayer?.day.desc ?? "")")
                Spacer()
                Text("အဓိဌာန်အဆင့် (\(vm.stage.toMyanmarDigits()))")
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.accent)

            Text("\(vm.currentPrayer?.mantra ?? "")")
                .font(.title)
                .fontWeight(.bold)

            Text("အပတ်ရေ (\((vm.currentPrayer?.rounds ?? 0).toMyanmarDigits()))ပတ်")
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
        let message = todayVegetarian ? "ဒီနေ့ သတ်သတ်လွတ်စားရန်" : "သတ်သတ်လွတ်စားရန် \(vm.dayUntilVegetarian.toMyanmarDigits()) ရက်အလို"
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
