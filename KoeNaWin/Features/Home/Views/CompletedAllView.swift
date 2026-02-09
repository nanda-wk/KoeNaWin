//
//  CompletedAllView.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-09.
//

import SwiftUI

struct CompletedAllView: View {
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "crown.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)

            Text("Congratulations!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Text("You have successfully completed the 81-day KoeNaWin practice.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.textSecondary)
        }
        .padding()
    }
}

#Preview {
    CompletedAllView()
}
