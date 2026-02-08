//
//  OnboardingScreen.swift
//  KoeNaWin
//
//  Created by Antigravity on 2026-02-08.
//

import SwiftUI

struct OnboardingScreen: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    @EnvironmentObject private var progressService: UserProgressService

    @State private var currentStep: Int = 0

    @State private var selectedLanguage: AppLanguage = .myanmar
    @State private var selectedDate = Date.now
    @State private var selectedBeadsType = "108"
    @State private var reminderTime = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()

    @State private var showDatePickerSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var error: CoreDataError?

    @Namespace private var namespace

    private let calendar = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar
    }()

    var body: some View {
        content
            .sheet(isPresented: $showDatePickerSheet) {
                datePickerSheet
            }
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
                    showDatePickerSheet = true
                }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                NotificationService.shared.requestAuthorization()
            }
    }
}

extension OnboardingScreen {
    private var content: some View {
        VStack {
            HStack(spacing: 8) {
                ForEach(0 ..< 4) { index in
                    Capsule()
                        .fill(index <= currentStep ? Color.accentColor : Color.appDivider)
                        .frame(width: index == currentStep ? 24 : 8, height: 8)
                }
                .animation(.spring, value: currentStep)
            }
            .padding(.top, 20)

            TabView(selection: Binding(
                get: { currentStep },
                set: { newValue in
                    if currentStep == 1, newValue > currentStep {
                        if isMonday(selectedDate) {
                            currentStep = newValue
                        }
                    } else {
                        currentStep = newValue
                    }
                }
            )) {
                languageStep.tag(0)
                dateStep.tag(1)
                beadsStep.tag(2)
                reminderStep.tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .highPriorityGesture(
                currentStep == 1 && !isMonday(selectedDate) ? DragGesture() : nil
            )

            navigationButtons
                .padding(.bottom, 30)
                .padding(.horizontal, 24)
        }
        .background(.appBackground)
    }

    // MARK: - Steps

    private var languageStep: some View {
        VStack(spacing: 30) {
            Image(systemName: "character.bubble.fill")
                .font(.system(size: 80))
                .foregroundStyle(.accent)

            VStack(spacing: 12) {
                Text("Select Language")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)

                Text("Choose your preferred language for the application.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.textSecondary)
                    .padding(.horizontal, 40)
            }

            LanguagePicker(selection: $selectedLanguage)
                .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top, 60)
    }

    private var dateStep: some View {
        VStack(spacing: 30) {
            Image(systemName: "calendar")
                .font(.system(size: 80))
                .foregroundStyle(.accent)

            VStack(spacing: 12) {
                Text("Start Your Journey")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)

                Text("When would you like to start your KoeNaWin - Practice?")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.textSecondary)
                    .padding(.horizontal, 40)

                Text("Rule: This Buddhist practice must start on a Monday.")
                    .font(.caption)
                    .italic()
                    .foregroundStyle(.accent)
            }

            Button {
                showDatePickerSheet = true
            } label: {
                HStack {
                    Text(selectedDate, style: .date)
                        .font(.headline)
                        .environment(\.locale, Locale(identifier: "en"))

                    Image(systemName: "chevron.right")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.appContent)
                .cornerRadius(26)
                .foregroundStyle(.textPrimary)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding(.top, 60)
    }

    private var beadsStep: some View {
        VStack(spacing: 30) {
            Image(systemName: "circle.hexagonpath")
                .font(.system(size: 80))
                .foregroundStyle(.accent)

            VStack(spacing: 12) {
                Text("Select Beads Type")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)

                Text("Choose the number of beads you will use for your practice.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.textSecondary)
                    .padding(.horizontal, 40)
            }

            VStack(spacing: 16) {
                beadOptionTile(title: "108 Beads", description: "Traditional long mala", type: "108")
                beadOptionTile(title: "9 Beads", description: "Portable wrist mala", type: "9")
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top, 60)
    }

    private var reminderStep: some View {
        VStack(spacing: 30) {
            Image(systemName: "bell.fill")
                .font(.system(size: 80))
                .foregroundStyle(.accent)

            VStack(spacing: 12) {
                Text("Daily Reminder")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)

                Text("Set a time to remind you of your daily practice.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.textSecondary)
                    .padding(.horizontal, 40)
            }

            DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .background(.appContent)
                .cornerRadius(26)
                .padding(.horizontal, 40)
                .environment(\.locale, Locale(identifier: "en"))

            Spacer()
        }
        .padding(.top, 60)
    }

    // MARK: - Components

    private func beadOptionTile(title: String, description: String, type: String) -> some View {
        Button {
            selectedBeadsType = type
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.textPrimary)

                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.textSecondary)
                }
                Spacer()
                if selectedBeadsType == type {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                }
            }
            .padding()
            .background(.appContent)
            .cornerRadius(26)
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(selectedBeadsType == type ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var navigationButtons: some View {
        HStack {
            if currentStep > 0 {
                Button("Back") {
                    withAnimation {
                        currentStep -= 1
                    }
                }
                .font(.headline)
                .foregroundStyle(.textSecondary)
            }

            Spacer()

            Button {
                if currentStep < 3 {
                    if userPreferences.appLanguage != selectedLanguage {
                        userPreferences.appLanguage = selectedLanguage
                    }
                    withAnimation {
                        currentStep += 1
                    }
                } else {
                    completeOnboarding()
                }
            } label: {
                Text(currentStep == 3 ? "Get Started" : "Next")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width: 140)
                    .background((currentStep == 1 && !isMonday(selectedDate)) ? Color.gray : Color.accentColor)
                    .cornerRadius(26)
            }
            .disabled(currentStep == 1 && !isMonday(selectedDate))
            .buttonStyle(.plain)
        }
    }

    private var datePickerSheet: some View {
        NavigationStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding(.horizontal)
                .environment(\.locale, Locale(identifier: "en_US_POSIX"))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            if isMonday(selectedDate) {
                                showDatePickerSheet = false
                            } else {
                                alertMessage = "Please select a Monday to start your practice."
                                showAlert = true
                            }
                        }
                        .tint(.accent)
                    }
                }
        }
        .presentationDetents([.fraction(0.65)])
    }

    private func completeOnboarding() {
        let beads = Int(selectedBeadsType) ?? 108
        let time = reminderTime.timeIntervalSince1970

        userPreferences.reminderTime = time
        userPreferences.beadsType = beads
        userPreferences.appLanguage = selectedLanguage
        userPreferences.isFirstLaunch = false

        if isSchedule(selectedDate) {
            progressService.setDailyReminder(reminderTime)
        } else {
            progressService.setNewCommitmentReminder(selectedDate)
        }

        do {
            try progressService.startNewCommitment(startDate: selectedDate)
        } catch {
            self.error = .failedToSave
            print(error.localizedDescription)
        }
    }

    private func isMonday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday == 2
    }

    private func isSchedule(_ date: Date) -> Bool {
        calendar.isDateInToday(date) && calendar.startOfDay(for: date) < calendar.startOfDay(for: .now)
    }
}

#Preview {
    OnboardingScreen()
        .previewEnviroments()
}
