//
//  OnboardingScreen.swift
//  KoeNaWin
//
//  Created by Antigravity on 2026-02-08.
//

import SwiftUI

struct OnboardingScreen: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @State private var currentStep: Int = 0

    @State private var selectedDate = Date.now
    @State private var selectedBeadsType = "108"
    @State private var reminderTime = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()

    @State private var showDatePickerSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Namespace private var namespace

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                ForEach(0 ..< 3) { index in
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
                    if currentStep == 0, newValue > currentStep {
                        if isMonday(selectedDate) {
                            currentStep = newValue
                        }
                    } else {
                        currentStep = newValue
                    }
                }
            )) {
                dateStep.tag(0)
                beadsStep.tag(1)
                reminderStep.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .highPriorityGesture(
                currentStep == 0 && !isMonday(selectedDate) ? DragGesture() : nil
            )

            navigationButtons
                .padding(.bottom, 30)
                .padding(.horizontal, 24)
        }
        .background(.appBackground)
        .sheet(isPresented: $showDatePickerSheet) {
            datePickerSheet
        }
        .alert("Invalid Date", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                showDatePickerSheet = true
            }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Steps

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
                if currentStep < 2 {
                    withAnimation {
                        currentStep += 1
                    }
                } else {
                    completeOnboarding()
                }
            } label: {
                Text(currentStep == 2 ? "Get Started" : "Next")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width: 140)
                    .background((currentStep == 0 && !isMonday(selectedDate)) ? Color.gray : Color.accentColor)
                    .cornerRadius(26)
            }
            .disabled(currentStep == 0 && !isMonday(selectedDate))
            .buttonStyle(.plain)
        }
    }

    private var datePickerSheet: some View {
        VStack {
            Button("Done") {
                if isMonday(selectedDate) {
                    showDatePickerSheet = false
                } else {
                    alertMessage = "Please select a Monday to start your practice."
                    showAlert = true
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)

            DatePicker("Select Start Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
        }
        .presentationDetents([.fraction(0.65)])
    }

    private func completeOnboarding() {
        userPreferences.reminderTime = reminderTime.timeIntervalSince1970
        userPreferences.beadsType = Int(selectedBeadsType) ?? 108
        userPreferences.isFirstLaunch = false
    }

    private func isMonday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday == 2
    }
}

#Preview {
    OnboardingScreen()
        .previewEnviroments()
}
