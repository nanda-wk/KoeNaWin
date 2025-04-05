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
            Image(.logo)
                .resizable()
                .frame(width: 90, height: 90)
                .clipShape(.rect(cornerRadius: 12))

            Text("KoeNaWin(ကိုးနဝင်း)")
                .font(.title)
                .fontWeight(.bold)

            ProgressView()
                .scaleEffect(1.5)
                .tint(.accent)
        }
    }
}

#Preview {
    LaunchScreen()
}
