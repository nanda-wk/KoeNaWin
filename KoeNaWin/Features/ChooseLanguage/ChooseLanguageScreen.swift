//
//  ChooseLanguageScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-06-18.
//

import SwiftUI

struct ChooseLanguageScreen: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            ForEach(AppLanguage.allCases) { language in
                LanguageListCell(for: language)
            }

            Spacer()
        }
        .padding()
        .background(.appBackground)
        .navigationTitle("Choose Language")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Next") {}
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
                .frame(width: 50, height: 40)
                .clipShape(.rect(cornerRadius: 12))

            Text(language.title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.accent)
        }
        .padding()
        .listSectionBackground
        .contentShape(Rectangle())
    }
}

#Preview {
    ChooseLanguageScreen()
}
