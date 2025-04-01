//
//  SettingsScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPrivacy = false

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    Image(.beads)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(.rect(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 5) {
                        Text("KoeNaWin(ကိုးနဝင်း)")
                            .font(.title3)
                            .fontWeight(.bold)

                        Text("V\(appVersion)")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.accent)
                    }
                }
            }

            Section {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.yellow)
                            )

                        Text("စတားပေးမယ်")
                            .font(.body)

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.primary)

                ShareLink(item: URL(string: "https://apps.apple.com/us")!) {
                    HStack {
                        Image(systemName: "square.and.arrow.up.fill")
                            .foregroundStyle(.white)
                            .font(.caption)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.blue)
                            )
                        Text("သူငယ်ချင်းတွေကို​ ရှဲမယ်")
                            .font(.body)

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.primary)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.white)
                            .font(.caption)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.pink)
                            )

                        Text("အကြံပြုချက်ပေးပို့မယ်")
                            .font(.body)

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.primary)
            }

            Section {
                Button {
                    showPrivacy.toggle()
                } label: {
                    HStack {
                        Image(systemName: "lock.shield.fill")
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.blue)
                            )

                        Text("Privacy Policy")
                            .font(.body)

                        Spacer()

                        Image(systemName: "link")
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .navigationTitle("ပြင်ဆင်ချက်")
        .navigationBarTitleDisplayMode(.inline)
        .popover(isPresented: $showPrivacy) {
            NavigationStack {
                WebView(url: "https://sites.google.com/view/koenawin/privacy")
                    .ignoresSafeArea(edges: .bottom)
                    .navigationTitle("Privacy Policy")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("", systemImage: "xmark.circle") {
                                showPrivacy.toggle()
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .previewEnvironment()
    }
}
