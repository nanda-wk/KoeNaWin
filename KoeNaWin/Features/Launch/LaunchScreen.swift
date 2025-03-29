//
//  LaunchScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        VStack {
            Text("KoeNaWin")
                .font(.largeTitle)
                .fontWeight(.bold)

            ProgressView("Loading...")
        }
    }
}

#Preview {
    LaunchScreen()
}
