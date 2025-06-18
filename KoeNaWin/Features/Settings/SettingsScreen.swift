//
//  SettingsScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import StoreKit
import SwiftUI

struct SettingsScreen: View {
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject private var configManager: ConfigManager
    @State private var startDate: Date = .now
    @State private var reminderDate: Date = .now
    @State private var showPrivacy = false
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var showAlert = false
    @State private var showChooseLanguage = false
    @State private var alertMessage: LocalizedStringKey = ""

    @State private var height: CGFloat = 500

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    Image(.logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(.rect(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 5) {
                        Text("KoeNaWin(ကိုးနဝင်း)")
                            .font(.title3)
                            .fontWeight(.bold)

                        Text("V\(appVersion)")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.accent)
                    }
                }
            }

            Section {
                appLanguage
                hapticToggle
                reminderTime
                appTheme
            }

            adhitthanStartDate

            Section {
                rateStars
                shareWithFriend
                suggestionFeedback
            }

            privacyPolicy
        }
        .navigationTitle("settingScreen-navTitle")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            startDate = vm.startDate
        }
        .sheet(isPresented: $showChooseLanguage) {
            ChooseLanguageScreen()
                .presentationDetents([.fraction(0.4)])
        }
        .sheet(isPresented: $showDatePicker) {
            VStack(alignment: .trailing) {
                Button("save") {
                    checkDate()
                }
                .padding()

                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .environment(\.locale, .init(identifier: "en_US_POSIX"))
            }
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .task {
                            height = proxy.size.height
                        }
                }
            )
            .id(height)
            .presentationDetents([.height(height)])
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("ok", role: .cancel) {
                showDatePicker.toggle()
            }
        }
        .popover(isPresented: $showPrivacy) {
            NavigationStack {
                WebView(url: "https://sites.google.com/view/koenawin/privacy")
                    .ignoresSafeArea(edges: .bottom)
                    .navigationTitle("privacy-policy")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("", systemImage: "xmark.circle") {
                                showPrivacy.toggle()
                            }
                        }
                    }
            }
        }
    }
}

extension SettingsScreen {
    var appLanguage: some View {
        Button {
            showChooseLanguage.toggle()
        } label: {
            HStack {
                Text("appLanguage")
                Spacer()
                Text(configManager.appLanguage.title)
                    .font(.headline)
                    .foregroundStyle(.accent)
            }
        }
        .foregroundStyle(.primary)
    }

    var hapticToggle: some View {
        Toggle("haptic-toggle", isOn: $configManager.isEnableHaptic)
            .tint(.accent)
    }

    @ViewBuilder
    var reminderTime: some View {
        if case .active = vm.status {
            Button {
                showTimePicker.toggle()
            } label: {
                HStack {
                    Text("reminder-time")
                        .font(.body)

                    Spacer()

                    Text(vm.reminderDate.toStringWith(format: .hMMa))
                        .font(.footnote)
                }
            }
            .foregroundStyle(.primary)
            .onAppear {
                reminderDate = vm.reminderDate
            }
            .sheet(isPresented: $showTimePicker) {
                VStack(alignment: .trailing) {
                    Button("save") {
                        vm.changeReminder(reminderDate)
                        showTimePicker.toggle()
                    }

                    DatePicker("", selection: $reminderDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .environment(\.locale, .init(identifier: "en_US_POSIX"))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .task {
                                height = proxy.size.height
                            }
                    }
                )
                .id(height)
                .presentationDetents([.height(height)])
                .interactiveDismissDisabled(true)
            }
            .onChange(of: vm.reminderDate) { _ in
                reminderDate = vm.reminderDate
            }
        }
    }

    var appTheme: some View {
        Picker("appearance", selection: $configManager.appTheme) {
            ForEach(AppTheme.allCases) { theme in
                Text(theme.rawValue)
                    .tag(theme)
            }
        }
    }

    var adhitthanStartDate: some View {
        Section {
            Button {
                showDatePicker.toggle()
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.orange)
                        )

                    Text("settingsScreen-adhitthan-start-date")
                        .font(.body)

                    Spacer()

                    Text(startDate.toStringWith(format: .yyyy_MMMM_d))
                        .font(.footnote)
                }
            }
            .foregroundStyle(.primary)
        } footer: {
            Text("settingsScreen-adhitthan-change-start-date")
        }
    }

    var rateStars: some View {
        Button {
            requestReview()
        } label: {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.yellow)
                    )

                Text("rate-app")
                    .font(.body)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.primary)
    }

    var shareWithFriend: some View {
        ShareLink(item: URL(string: "https://apps.apple.com/us/app/koenawin-practice/id6747106061")!) {
            HStack {
                Image(systemName: "square.and.arrow.up.fill")
                    .foregroundStyle(.white)
                    .font(.caption)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.blue)
                    )
                Text("share-with-friends")
                    .font(.body)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.primary)
    }

    var suggestionFeedback: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.white)
                    .font(.caption)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.pink)
                    )

                Text("send-feedback")
                    .font(.body)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.primary)
    }

    var privacyPolicy: some View {
        Section {
            Button {
                showPrivacy.toggle()
            } label: {
                HStack {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.blue)
                        )

                    Text("privacy-policy")
                        .font(.body)

                    Spacer()

                    Image(systemName: "link")
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
        }
    }
}

extension SettingsScreen {
    private func checkDate() {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let today = Date.now

        // Check if startDate is in the future
        if startDate > today {
            startDate = vm.startDate
            alertMessage = "settingScreen-alert-isFuture"
            showAlert.toggle()
            return
        }

        // Check if startDate is within 81 days from today
        let minDate = calendar.date(byAdding: .day, value: -81, to: today)!
        if startDate < minDate {
            startDate = vm.startDate
            alertMessage = "settingScreen-alert-isPast-date"
            showAlert.toggle()
            return
        }

        // Check if startDate is Monday
        if calendar.component(.weekday, from: startDate) != 2 {
            startDate = vm.startDate
            alertMessage = "settingScreen-alert-not-monday"
            showAlert.toggle()
        } else {
            vm.changeStartDate(startDate)
            showDatePicker = false
            showTimePicker = false
        }
        Haptic.selection.generate()
    }

    private func sendFeedback() {
        let mailtoString = "mailto:nandawinkyu.ix@gmail.com?subject=KoeNaWin App feedback".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailToUrl = URL(string: mailtoString!)!

        if UIApplication.shared.canOpenURL(mailToUrl) {
            UIApplication.shared.open(mailToUrl, options: [:])
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .previewEnvironment()
    }
}
