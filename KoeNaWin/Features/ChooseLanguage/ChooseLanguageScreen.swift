//
//  ChooseLanguageScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-06-18.
//

import SwiftUI

struct ChooseLanguageScreen: View {
    @EnvironmentObject private var configManager: ConfigManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ForEach(AppLanguage.allCases) { language in
                    LanguageListCell(for: language)
                }

                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("chooseLanguage-navTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if configManager.isFirstLaunch {
                    Button("next") {
                        configManager.isFirstLaunch = false
                    }
                }
            }
        }
    }
}

extension ChooseLanguageScreen {
    @ViewBuilder
    private func LanguageListCell(for language: AppLanguage) -> some View {
        HStack(alignment: .center, spacing: 15) {
            Image(language.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .clipShape(.rect(cornerRadius: 12))

            Text(language.title)
                .font(.subheadline)
                .fontWeight(.bold)

            Spacer()

            if language == configManager.appLanguage {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.accent)
            }
        }
        .padding()
        .listSectionBackground
        .contentShape(Rectangle())
        .onTapGesture {
            configManager.appLanguage = language
        }
    }
}

#Preview {
    ChooseLanguageScreen()
        .previewEnvironment()
}
