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
    @Binding var selectedTab: TabItem
    @Binding var path: NavigationPath
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            if vm.isLoading {
                ProgressView("Loading...")
                    .scaleEffect(1.5)
                    .tint(.accent)
            } else if case .active = vm.status {
                List {
                    vegetarianSection

                    todayMantra

                    currentStageCompletion

                    completionSection
                }
                .listSectionSpacing(25)
            } else {
                NoticeCard(status: vm.status)
            }
        }
        .navigationTitle("ကိုးနဝင်း")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.checkProgress()
        }
    }
}

extension HomeScreen {
    var completionSection: some View {
        Section {
            VStack {
                Text("အဓိဌာန်ပြီးမြောက်မှု")
                    .font(.title2)
                    .fontWeight(.bold)

                HStack {
                    Chart {
                        SectorMark(
                            angle: .value("Done", vm.totalDay),
                            innerRadius: .ratio(0.65),
                            angularInset: 2
                        )
                        .cornerRadius(10)

                        SectorMark(
                            angle: .value("In Progress", 81 - vm.totalDay),
                            innerRadius: .ratio(0.65),
                            angularInset: 2
                        )
                        .foregroundStyle(.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .chartBackground { _ in
                        Text("\(vm.totalDay.toMyanmarDigits()) / ၈၁")
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
        }
    }

    var currentStageCompletion: some View {
        Section {
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
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let currentStage = koeNaWinStages.first(where: { $0.stage == vm.stage }) {
                selectedTab = .stages
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
        Section {
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
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedTab = .practice
        }
    }

    @ViewBuilder
    var vegetarianSection: some View {
        let todayVegetarian = vm.dayUntilVegetarian == 0
        let message = todayVegetarian ? "ဒီနေ့ သတ်သတ်လွတ်စားရန်" : "သတ်သတ်လွတ်စားရန် \(vm.dayUntilVegetarian.toMyanmarDigits()) ရက်အလို"
        if vm.stage == 9, vm.day > 5 {
            EmptyView()
        } else {
            Section {
                Text(message)
                    .font(.headline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen(selectedTab: .constant(.home), path: .constant(NavigationPath()))
            .previewEnvironment()
    }
}
