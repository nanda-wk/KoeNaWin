//
//  ScheduledView.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-09.
//

import SwiftUI

struct ScheduledView: View {
    let date: Date

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.mind.and.body")
                .font(.system(size: 60))
                .foregroundStyle(.accent)

            Text("Practice Scheduled")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.accent)

            Text("Your practice starts on")
                .foregroundStyle(.textSecondary)

            Text(date.toStringWith(format: .yyyy_MMMM_d))
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            HStack {
                Image(systemName: "calendar")
                Text("Get ready for Day 1")
            }
            .font(.subheadline)
            .foregroundStyle(.textPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .listSectionBackground
        .padding(24)
    }
}

#Preview {
    ScheduledView(date: .now)
}
