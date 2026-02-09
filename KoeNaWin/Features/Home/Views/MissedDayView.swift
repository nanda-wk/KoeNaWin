//
//  MissedDayView.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-09.
//

import SwiftUI

struct MissedDayView: View {
    let date: Date

    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange)

            Text("Missed Practice")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Text("You missed your practice on \n\(date.formatted(date: .abbreviated, time: .omitted)).")
                .multilineTextAlignment(.center)
                .foregroundStyle(.textSecondary)

            Text("Stage \(1), Day \(2)")
                .font(.subheadline)
                .foregroundStyle(.textPrimary)

            Button {
                // Action to resolve
            } label: {
                Text("Resolve Missed Day")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Capsule().fill(.accent))
            }
        }
        .padding()
        .listSectionBackground
        .padding(24)
    }
}

#Preview {
    MissedDayView(date: .now)
}
