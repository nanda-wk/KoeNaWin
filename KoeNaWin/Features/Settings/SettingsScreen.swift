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

    @State private var height: CGFloat = 500

    var body: some View {
        List {
            Section {
                appInfo
            }

            Section {
                appLanguage
                hapticToggle
                reminderTime
                appTheme
            }

            beadsCount
            adhitthanStartDate

            Section {
                rateStars
                shareWithFriend
                suggestionFeedback
            }

            privacyPolicy
        }
        .scrollIndicators(.never)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {}
        .sheet(isPresented: .constant(false)) {
            ChooseLanguageScreen()
                .presentationDetents([.fraction(0.4)])
        }
        .sheet(isPresented: .constant(false)) {
            VStack(alignment: .trailing) {
                Button("Save") {}
                    .padding()

                DatePicker("", selection: .constant(.now), displayedComponents: .date)
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
        .alert("alertMessage", isPresented: .constant(false)) {
            Button("OK", role: .cancel) {}
        }
        .sheet(isPresented: .constant(false)) {
            NavigationStack {
                WebView(url: "https://sites.google.com/view/koenawin/privacy")
                    .ignoresSafeArea(edges: .bottom)
                    .navigationTitle("Privacy Policy")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("", systemImage: "xmark.circle") {}
                        }
                    }
            }
        }
    }
}

extension SettingsScreen {
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

                Text("V\(appVersion)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
            }
        }
    }

    private var appLanguage: some View {
        Button {} label: {
            HStack {
                Text("App Language")
                Spacer()
                Text("English")
                    .font(.headline)
                    .foregroundStyle(.accent)
            }
        }
        .foregroundStyle(.textPrimary)
    }

    private var hapticToggle: some View {
        Toggle("Haptic on", isOn: .constant(true))
            .tint(.accent)
            .foregroundStyle(.textPrimary)
    }

    @ViewBuilder
    private var reminderTime: some View {
        Button {} label: {
            HStack {
                Text("Reminder Time")
                    .font(.body)

                Spacer()

                Text("08:00 PM")
                    .font(.footnote)
            }
        }
        .foregroundStyle(.textPrimary)
        .onAppear {}
        .sheet(isPresented: .constant(false)) {
            VStack(alignment: .trailing) {
                Button("Save") {}

                DatePicker("", selection: .constant(.now), displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "en"))
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
    }

    private var appTheme: some View {
        Picker("Appearance", selection: .constant(AppTheme.system)) {
            ForEach(AppTheme.allCases) { theme in
                Text(theme.rawValue)
                    .tag(theme)
            }
        }
        .foregroundStyle(.textPrimary)
    }

    private var adhitthanStartDate: some View {
        Section {
            Button {} label: {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.orange)
                        )

                    Text("Adhitthan Start Date")
                        .font(.body)

                    Spacer()

                    Text(Date.now.toStringWith(format: .yyyy_MMMM_d))
                        .font(.footnote)
                }
            }
            .foregroundStyle(.textPrimary)
        } footer: {
            Text("Change Adhitthan start date.")
        }
    }

    private var beadsCount: some View {
        Section {
            Picker("Total Beads", selection: .constant(108)) {
                ForEach([108, 9], id: \.self) { count in
                    Text("\(count)")
                        .tag(count)
                }
            }
        } footer: {
            Text("Change prefer beads count.")
        }
        .foregroundStyle(.textPrimary)
    }

    private var rateStars: some View {
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

                Text("Rate app")
                    .font(.body)
                    .foregroundStyle(.textPrimary)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.textSecondary)
            }
        }
    }

    private var shareWithFriend: some View {
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
                Text("Share with friends")
                    .font(.body)
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
                    .foregroundStyle(.white)
                    .font(.caption)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.pink)
                    )

                Text("Send Feedback")
                    .font(.body)
                    .foregroundStyle(.textPrimary)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.textSecondary)
            }
        }
    }

    private var privacyPolicy: some View {
        Section {
            Button {} label: {
                HStack {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.blue)
                        )

                    Text("Privacy Policy")
                        .font(.body)
                        .foregroundStyle(.textPrimary)

                    Spacer()

                    Image(systemName: "link")
                        .foregroundStyle(.textSecondary)
                }
            }
        }
    }
}

extension SettingsScreen {
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
    }
}
