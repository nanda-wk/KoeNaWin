//
//  SettingsScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject private var configManager: ConfigManager
    @State private var startDate: Date = .now
    @State private var reminderDate: Date = .now
    @State private var showPrivacy = false
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

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
                hapticToggle
                reminderTime
                appTheme
            }

            addithanStartDate

            Section {
                rateStart
                shareWithFriend
                suggestionFeedback
            }

            privacyPolicy
        }
        .navigationTitle("ပြင်ဆင်ချက်")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            startDate = vm.startDate
            reminderDate = vm.reminderDate
        }
        .sheet(isPresented: $showDatePicker) {
            VStack(alignment: .trailing) {
                Button("သိမ်းဆည်းမည်") {
                    checkDate()
                }
                .padding()

                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .environment(\.locale, Locale(identifier: "my_MM"))
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
            .interactiveDismissDisabled(true)
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("အိုကေ", role: .cancel) {
                showDatePicker.toggle()
            }
        }
        .popover(isPresented: $showPrivacy) {
            NavigationStack {
                WebView(url: "https://sites.google.com/view/koenawin/privacy")
                    .ignoresSafeArea(edges: .bottom)
                    .navigationTitle("Privacy Policy")
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
    var hapticToggle: some View {
        Toggle("တုန်ခါမှု ဖွင့်မယ်", isOn: $configManager.isEnableHaptic)
            .tint(.accent)
    }

    @ViewBuilder
    var reminderTime: some View {
        if case .active = vm.status {
            Button {
                showTimePicker.toggle()
            } label: {
                HStack {
                    Text("သတိပေးချက်အချိန်")
                        .font(.body)

                    Spacer()

                    Text(vm.reminderDate.toStringWith(format: .hMMa))
                        .font(.footnote)
                }
            }
            .foregroundStyle(.primary)
            .sheet(isPresented: $showTimePicker) {
                VStack(alignment: .trailing) {
                    Button("သိမ်းဆည်းမည်") {
                        vm.changeReminder(reminderDate)
                        showTimePicker.toggle()
                    }

                    DatePicker("", selection: $reminderDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "my_MM"))
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
        Picker("အက်ပ် အသွင်အပြင်", selection: $configManager.appTheme) {
            ForEach(AppTheme.allCases) { theme in
                Text(theme.rawValue)
                    .tag(theme)
            }
        }
    }

    var addithanStartDate: some View {
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

                    Text("အဓိဌာန်စတင်ရက်")
                        .font(.body)

                    Spacer()

                    Text(startDate.toStringWith(format: .yyyy_MMMM_d))
                        .font(.footnote)
                }
            }
            .foregroundStyle(.primary)
        } footer: {
            Text("အဓိဌာန်စတင်မည့်ရက်ကို ပြောင်းလဲရန် အပေါ်က ခလုတ်ကို နှိပ်ပါ။")
        }
    }

    var rateStart: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.yellow)
                    )

                Text("စတားပေးမယ်")
                    .font(.body)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.primary)
    }

    var shareWithFriend: some View {
        ShareLink(item: URL(string: "https://apps.apple.com/us")!) {
            HStack {
                Image(systemName: "square.and.arrow.up.fill")
                    .foregroundStyle(.white)
                    .font(.caption)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.blue)
                    )
                Text("သူငယ်ချင်းတွေကို​ ရှဲမယ်")
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

                Text("အကြံပြုချက်ပေးပို့မယ်")
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

                    Text("Privacy Policy")
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
            alertMessage = "နောင်အနာဂတ်ရက်များကို ရွေးချယ်၍မရပါ"
            showAlert.toggle()
            return
        }

        // Check if startDate is within 81 days from today
        let minDate = calendar.date(byAdding: .day, value: -81, to: today)!
        if startDate < minDate {
            startDate = vm.startDate
            alertMessage = "ရက် ၈၁ ရက်ထက်ကျော်လွန်သော ရက်များကို ရွေးချယ်၍မရပါ"
            showAlert.toggle()
            return
        }

        // Check if startDate is Monday
        if calendar.component(.weekday, from: startDate) != 2 {
            startDate = vm.startDate
            alertMessage = "တနင်္လာနေ့ကိုသာ ရွေးချယ်ပေးပါ"
            showAlert.toggle()
        } else {
            vm.changeStartDate(startDate)
            showDatePicker = false
            showTimePicker = false
        }
        Haptic.selection.generate()
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .previewEnvironment()
    }
}
