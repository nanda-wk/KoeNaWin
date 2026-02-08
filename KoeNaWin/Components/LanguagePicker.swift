//
//  LanguagePicker.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import SwiftUI

struct LanguagePicker: View {
    @Binding var selection: AppLanguage

    var body: some View {
        VStack(spacing: 16) {
            ForEach(AppLanguage.allCases) { language in
                Button {
                    selection = language
                } label: {
                    HStack {
                        Image(language.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .cornerRadius(8)

                        Text(language.title)
                            .font(.headline)
                            .foregroundStyle(.textPrimary)

                        Spacer()

                        if selection == language {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.accent)
                        }
                    }
                    .padding()
                    .background(.appContent)
                    .cornerRadius(26)
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                            .stroke(selection == language ? .accent : .clear, lineWidth: 2)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
