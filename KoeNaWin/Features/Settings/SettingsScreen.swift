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
    @EnvironmentObject private var userPreferences: UserPreferences
    @EnvironmentObject private var journeyService: JourneyService

    @State private var selectedDate = Date.today()

    @State private var height: CGFloat = 500
    @State private var sheet: SheetType?

    @State private var error: CoreDataError?
    @State private var showAlert = false
    @State private var alertMessage: LocalizedStringKey = ""

    var body: some View {
        content
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                isPresented: Binding(
                    get: { error != nil },
                    set: { _ in error = nil }
                ),
                error: error
            ) {
                Button("OK") {}
            }
            .alert("Invalid Date", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    sheet = .startDate
                }
            } message: {
                Text(alertMessage)
            }
            .sheet(item: $sheet) { sheet in
                NavigationStack {
                    switch sheet {
                    case .language:
                        languagePicker
                    case .reminder:
                        reminderPicker
                    case .startDate:
                        startDatePicker
                    case .privacyPolicy:
                        privacyPolicyWebView
                    }
                }
            }
    }
}

extension SettingsScreen {
    private var content: some View {
        ScrollView {
            VStack(spacing: 25) {
                appInfo
                appPreferences
                beadsCount
                adhitthanStartDate
                socialSection
                privacyPolicy
            }
            .padding()
        }
        .scrollIndicators(.never)
        .background(.appBackground)
    }

    private var appInfo: some View {
        HStack(spacing: 14) {
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipShape(.rect(cornerRadius: 18))

            VStack(alignment: .leading, spacing: 5) {
                Text("KoeNaWin(ကိုးနဝင်း)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)

                Text("V\(Constants.appVersion)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
            }
            Spacer()
        }
        .padding()
        .listSectionBackground
    }

    private var appPreferences: some View {
        VStack(spacing: 18) {
            appLanguage
            Divider()
                .foregroundStyle(.appDivider)
            hapticToggle
            Divider()
                .foregroundStyle(.appDivider)
            reminderTime
            Divider()
                .foregroundStyle(.appDivider)
            appTheme
        }
        .padding()
        .listSectionBackground
    }

    private var appLanguage: some View {
        Button {
            sheet = .language
        } label: {
            HStack {
                Text("App Language")
                Spacer()
                Text(userPreferences.appLanguage.title)
                    .font(.headline)
                    .foregroundStyle(.accent)
            }
            .contentShape(.rect)
        }
        .foregroundStyle(.textPrimary)
        .buttonStyle(.plain)
    }

    private var languagePicker: some View {
        LanguagePicker(selection: $userPreferences.appLanguage)
            .padding()
            .navigationTitle("Choose Your Language")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.fraction(0.4)])
    }

    private var hapticToggle: some View {
        Toggle("Haptic on", isOn: $userPreferences.isEnableHaptic)
            .tint(.accent)
            .foregroundStyle(.textPrimary)
    }

    private var reminderTime: some View {
        Button {
            sheet = .reminder
        } label: {
            HStack {
                Text("Reminder Time")
                Spacer()
                Text(Date(timeIntervalSince1970: userPreferences.reminderTime), style: .time)
                    .environment(\.locale, Locale(identifier: "en"))
            }
            .contentShape(.rect)
        }
        .foregroundStyle(.textPrimary)
        .buttonStyle(.plain)
    }

    private var reminderPicker: some View {
        DatePicker(
            "",
            selection: Binding(
                get: { Date(timeIntervalSince1970: userPreferences.reminderTime)
                },
                set: { userPreferences.reminderTime = $0.timeIntervalSince1970 }
            ),
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .navigationTitle("Daily Reminder at ")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .environment(\.locale, Locale(identifier: "en"))
        .presentationDetents([.medium])
        .onDisappear {
            journeyService.setDailyReminder(Date(timeIntervalSince1970: userPreferences.reminderTime))
        }
    }

    private var appTheme: some View {
        HStack {
            Text("Appearance")
            Spacer()
            Picker("", selection: $userPreferences.appTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.rawValue)
                        .tag(theme)
                }
            }
            .tint(.textSecondary)
        }
        .foregroundStyle(.textPrimary)
    }

    private var beadsCount: some View {
        VStack {
            HStack {
                Text("Total Beads")
                Spacer()
                Picker("", selection: $userPreferences.beadsType) {
                    ForEach([108, 9], id: \.self) { count in
                        Text("\(count)")
                            .tag(count)
                    }
                }
                .tint(.textSecondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .listSectionBackground

            Text("Change prefer beads count.")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
        .foregroundStyle(.textPrimary)
        .onChange(of: userPreferences.beadsType) { _ in
            userPreferences.resetbeads()
        }
    }

    private var adhitthanStartDate: some View {
        VStack {
            Button {
                sheet = .startDate
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.white)
                        .font(.caption)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.orange)
                        )

                    Text("Adhitthan Start Date")

                    Spacer()

                    if let startDate = journeyService.startDate {
                        Text(startDate.toStringWith(format: .yyyy_MMMM_d))
                            .font(.footnote)
                    } else {
                        Text("Not Started")
                            .font(.footnote)
                            .foregroundStyle(.textSecondary)
                    }
                }
                .padding()
                .listSectionBackground
            }
            .buttonStyle(.plain)

            Text("Change Adhitthan start date.")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
        .foregroundStyle(.textPrimary)
    }

    private var startDatePicker: some View {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .labelsHidden()
            .padding(.horizontal)
            .environment(\.locale, Locale(identifier: "en_US_POSIX"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        if selectedDate.isMonday() {
                            do {
                                try journeyService.startNewJourney(startDate: selectedDate)
                                userPreferences.resetbeads()
                                sheet = nil
                            } catch {
                                self.error = .failedToSave
                                print(error.localizedDescription)
                            }
                        } else {
                            alertMessage = "Please select a Monday to start your commitment."
                            showAlert = true
                        }
                    }
                    .tint(.accent)
                }
            }
            .presentationDetents([.fraction(0.65)])
    }

    private var socialSection: some View {
        VStack(spacing: 18) {
            rateStars
            Divider()
                .foregroundStyle(.appDivider)
            shareWithFriend
            Divider()
                .foregroundStyle(.appDivider)
            suggestionFeedback
        }
        .padding()
        .listSectionBackground
    }

    private var rateStars: some View {
        Button {
            requestReview()
        } label: {
            HStack {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.yellow)
                    )

                Text("Rate app")
                    .foregroundStyle(.textPrimary)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.textSecondary)
            }
        }
    }

    private var shareWithFriend: some View {
        ShareLink(item: URL(string: Constants.appStoreLink)!) {
            HStack {
                Image(systemName: "square.and.arrow.up.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.blue)
                    )

                Text("Share with friends")
                    .foregroundStyle(.textPrimary)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.textSecondary)
            }
        }
    }

    private var suggestionFeedback: some View {
        Button(action: sendFeedback) {
            HStack {
                Image(systemName: "paperplane.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.pink)
                    )

                Text("Send Feedback")
                    .foregroundStyle(.textPrimary)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.textSecondary)
            }
        }
    }

    private var privacyPolicy: some View {
        Button {
            sheet = .privacyPolicy
        } label: {
            HStack {
                Image(systemName: "lock.shield.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.blue)
                    )

                Text("Privacy Policy")
                    .foregroundStyle(.textPrimary)

                Spacer()

                Image(systemName: "link")
                    .foregroundStyle(.textSecondary)
            }
            .padding()
            .listSectionBackground
        }
        .buttonStyle(.plain)
    }

    private var privacyPolicyWebView: some View {
        WebView(url: Constants.privacyPolicy)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarClose
            }
    }

    @ToolbarContentBuilder
    private var toolbarClose: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("", systemImage: "xmark.circle") {
                self.sheet = nil
            }
        }
    }
}

extension SettingsScreen {
    private func sendFeedback() {
        let mailtoString = "mailto:\(Constants.email)?subject=KoeNaWin App feedback".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailToUrl = URL(string: mailtoString!)!

        if UIApplication.shared.canOpenURL(mailToUrl) {
            UIApplication.shared.open(mailToUrl, options: [:])
        }
    }
}

extension SettingsScreen {
    enum SheetType: Int, Identifiable {
        var id: Int { rawValue }
        case language, reminder, startDate, privacyPolicy
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .previewEnviroments()
    }
}
