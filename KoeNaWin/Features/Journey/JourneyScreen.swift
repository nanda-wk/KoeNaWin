//
//  JourneyScreen.swift
//  KoeNaWin
//
//  Created by Antigravity on 2026-02-08.
//

import SwiftUI

struct JourneyScreen: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    @EnvironmentObject private var journeyService: JourneyService
    @EnvironmentObject private var router: Router

    let mode: JourneyMode

    @State private var currentStep: Int

    @State private var selectedLanguage: AppLanguage = .myanmar
    @State private var selectedDate = Date.today()
    @State private var selectedBeadsType = 108
    @State private var reminderTime = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: .today()) ?? .today()

    @State private var showDatePickerSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var error: CoreDataError?

    init(mode: JourneyMode = .onboarding) {
        self.mode = mode
        _currentStep = State(initialValue: mode == .newCommitment ? 1 : 0)
    }

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

extension JourneyScreen {
    private var content: some View {
        VStack {
            stepIndicator

            TabView(selection: Binding(
                get: { currentStep },
                set: { newValue in
                    if currentStep == 1, newValue > currentStep {
                        if selectedDate.isMonday() {
                            currentStep = newValue
                        }
                    } else {
                        currentStep = newValue
                    }
                }
            )) {
                Group {
                    if mode == .onboarding {
                        languageStep.tag(0)
                    }
                    dateStep.tag(1)
                    beadsStep.tag(2)
                    reminderStep.tag(3)
                }
                .padding(.top, 44)
                .padding(.horizontal, 24)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .highPriorityGesture(
                currentStep == 1 && !selectedDate.isMonday() ? DragGesture() : nil
            )

            navigationButtons
                .padding(.bottom, 30)
                .padding(.horizontal, 24)
        }
        .background(.appBackground)
    }

    private var stepIndicator: some View {
        HStack(spacing: 8) {
            let range = mode == .newCommitment ? 1 ..< 4 : 0 ..< 4
            ForEach(Array(range), id: \.self) { index in
                Capsule()
                    .fill(index <= currentStep ? .accent : .appDivider)
                    .frame(width: index == currentStep ? 24 : 8, height: 8)
            }
        }
        .animation(.spring, value: currentStep)
        .padding(.top)
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
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.textSecondary)
            }

            LanguagePicker(selection: $selectedLanguage)

            Spacer()
        }
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

                Text("When would you like to start your \nKoeNaWin - Practice?")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.textSecondary)

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

            Spacer()
        }
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

                Text("Choose the number of beads you \nwill use for your practice.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.textSecondary)
            }

            VStack(spacing: 16) {
                beadOptionTile(title: "108 Beads", description: "Traditional long mala", type: 108)
                beadOptionTile(title: "9 Beads", description: "Portable wrist mala", type: 9)
            }

            Spacer()
        }
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

                Text("Set a time to remind you of your \ndaily practice.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.textSecondary)
            }

            DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .background(.appContent)
                .cornerRadius(26)
                .environment(\.locale, Locale(identifier: "en"))

            Spacer()
        }
    }

    // MARK: - Components

    private func beadOptionTile(title: String, description: String, type: Int) -> some View {
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
                    .stroke(selectedBeadsType == type ? .accent : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var navigationButtons: some View {
        HStack {
            let canGoBack = mode == .newCommitment ? currentStep > 1 : currentStep > 0
            if canGoBack {
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
                    .background((currentStep == 1 && !selectedDate.isMonday()) ? .gray : .accent)
                    .cornerRadius(26)
            }
            .disabled(currentStep == 1 && !selectedDate.isMonday())
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
                            if selectedDate.isMonday() {
                                showDatePickerSheet = false
                            } else {
                                alertMessage = "Please select a Monday to start your commitment."
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
        userPreferences.reminderTime = reminderTime.timeIntervalSince1970
        userPreferences.beadsType = selectedBeadsType
        if mode == .onboarding {
            userPreferences.appLanguage = selectedLanguage
            userPreferences.isFirstLaunch = false
            userPreferences.isEnableHaptic = true
        }

        let startDate = selectedDate.startOfDay()

        if startDate > Date.today() {
            journeyService.setNewCommitmentReminder(startDate)
        } else {
            journeyService.setDailyReminder(reminderTime)
        }

        do {
            try journeyService.startNewJourney(startDate: startDate)
            router.dismissSheet()
        } catch {
            self.error = .failedToSave
            print(error.localizedDescription)
        }
    }
}

extension JourneyScreen {
    enum JourneyMode {
        case onboarding
        case newCommitment
    }
}

#Preview {
    JourneyScreen()
        .previewEnviroments()
}

#Preview("Add New") {
    JourneyScreen(mode: .newCommitment)
        .previewEnviroments()
}
