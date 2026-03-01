//
//  MissedDayView.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-09.
//

import SwiftUI

struct MissedDayView: View {
    @EnvironmentObject private var router: Router
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

            Text("You missed your practice on \n\(date.toStringWith(format: .yyyy_MMMM_d)).")
                .multilineTextAlignment(.center)
                .foregroundStyle(.textSecondary)

            Spacer()
                .frame(height: 20)

            Button {
                router.presentedSheet = .journey(.newCommitment)
            } label: {
                Text("Resolve Missed Day")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Capsule().fill(.accent))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .listSectionBackground
        .padding(24)
    }
}

#Preview {
    MissedDayView(date: .now)
        .previewEnviroments()
}
