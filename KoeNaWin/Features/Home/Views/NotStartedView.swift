//
//  NotStartedView.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-09.
//

import SwiftUI

struct NotStartedView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.mind.and.body")
                .font(.system(size: 60))
                .foregroundStyle(.accent)

            Text("Begin Your Journey")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Text("Ready to start your 81-day KoeNaWin practice? Set your start date and begin your spiritual discipline.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.textSecondary)
                .padding(.horizontal)

            Button {
                isPresented.toggle()
            } label: {
                Text("Get Started")
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
    NotStartedView(isPresented: .constant(false))
}
