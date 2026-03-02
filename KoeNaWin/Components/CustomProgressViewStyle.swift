//
//  CustomProgressViewStyle.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct CustomProgressViewStyle: ProgressViewStyle {
    var height: CGFloat = 12
    var progress: Color = .accent
    var background: Color = .gray.opacity(0.2)
    @State private var animatedProgress: CGFloat = 0
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 10) {
            // Include the label from the original ProgressView
            configuration.label

            // Custom progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: height)
                        .foregroundStyle(background)

                    // Progress
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: CGFloat(animatedProgress) * geometry.size.width, height: height)
                        .foregroundStyle(progress)
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 0.8)) {
                        animatedProgress = CGFloat(configuration.fractionCompleted ?? 0)
                    }
                }
                .onChange(of: configuration.fractionCompleted ?? 0) { newValue in
                    withAnimation(.easeOut(duration: 0.8)) {
                        animatedProgress = CGFloat(newValue)
                    }
                }
            }
            .frame(height: height) // Match the height above

            configuration.currentValueLabel
        }
    }
}
