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
        VStack(spacing: 15) {
            Text("Practice Scheduled")
                .font(.headline)
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
