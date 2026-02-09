//
//  CircularProgressView.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    var thickness: CGFloat = 20
    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray.opacity(0.2), lineWidth: thickness)
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(.accent, style: StrokeStyle(
                    lineWidth: thickness,
                    lineCap: .round
                ))
                .rotationEffect(.degrees(-90))
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = newValue
            }
        }
    }
}
