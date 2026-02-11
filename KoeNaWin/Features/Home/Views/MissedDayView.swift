//
//  MissedDayView.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-09.
//

import SwiftUI

struct MissedDayView: View {
    @Binding var isPresented: Bool
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

            Button {
                isPresented.toggle()
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
    MissedDayView(isPresented: .constant(false), date: .now)
}
