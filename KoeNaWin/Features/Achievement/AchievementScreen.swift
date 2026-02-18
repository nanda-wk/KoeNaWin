//
//  AchievementScreen.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Photos
import SwiftUI
import UIKit

struct AchievementScreen: View {
    @EnvironmentObject private var journeyService: JourneyService
    @EnvironmentObject private var router: Router
    @State private var exportedPreviewImage: UIImage?
    @State private var exportedBadgeURL: URL?
    @State private var saveMessage = ""
    @State private var showSaveAlert = false
    @State private var isGenerating = false

    private let cardWidth: CGFloat = 340
    private let cardHeight: CGFloat = 620

    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    Button("", systemImage: "xmark.circle") {
                        router.dismissSheet()
                    }
                }
                .toolbarBackground(.hidden)
                .alert("Photo Save", isPresented: $showSaveAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(saveMessage)
                }
                .onAppear {
                    if exportedBadgeURL == nil {
                        generateBadgeImage()
                    }
                }
        }
    }
}

extension AchievementScreen {
    private var content: some View {
        ScrollView {
            VStack(spacing: 20) {
                badgeCard
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    shareButton

                    Text("Share your completion with friends and family.")
                        .font(.footnote)
                        .foregroundStyle(.textSecondary)
                }
                .padding([.horizontal, .bottom])
            }
            .padding(.top, 8)
        }
        .background(backgroundGradient.ignoresSafeArea())
        .scrollBounceBehavior(.basedOnSize)
    }

    private var badgeCard: some View {
        AchievementBadgeCard(
            totalDays: max(81, journeyService.totalDays),
            completionDate: Date.today().toStringWith(format: .yyyy_MMMM_d)
        )
        .shadow(color: .black.opacity(0.35), radius: 25, x: 0, y: 20)
    }

    @ViewBuilder
    private var shareButton: some View {
        if let exportedBadgeURL {
            ShareLink(
                item: exportedBadgeURL,
                preview: SharePreview(
                    "I completed Koe Na Win without missing a day.",
                    image: exportedPreviewImage.map { Image(uiImage: $0) } ?? Image(systemName: "medal.star.fill")
                )
            ) {
                HStack(spacing: 10) {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Share My Badge")
                        .fontWeight(.bold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.accent)
                .clipShape(.capsule)
            }
            .buttonStyle(.plain)
        } else {
            HStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                Text(isGenerating ? "Preparing your badge..." : "Preparing...")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(.accent.opacity(0.55))
            .clipShape(.capsule)
        }
    }
}

private struct AchievementBadgeCard: View {
    let totalDays: Int
    let completionDate: String

    var body: some View {
        ZStack {
            Color(.appContent)

            RoundedRectangle(cornerRadius: 24)
                .stroke(.accent.opacity(0.28), lineWidth: 1.2)
                .padding(10)

            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Image(.logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(.rect(cornerRadius: 12))

                    Text("KOE NA WIN")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .kerning(3)
                        .foregroundStyle(.textPrimary)

                    Text("SACRED JOURNEY COMPLETED")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .kerning(2)
                        .foregroundStyle(.textSecondary)
                }

                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.accent.opacity(0.18), .accent.opacity(0.06)],
                                center: .center,
                                startRadius: 6,
                                endRadius: 70
                            )
                        )
                        .frame(width: 140, height: 140)
                    Circle()
                        .stroke(.accent.opacity(0.65), lineWidth: 2)
                        .frame(width: 140, height: 140)

                    VStack(spacing: 4) {
                        Image(systemName: "medal.star.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.accent)
                        Text("9 / 9")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.textPrimary)
                        Text("STAGES")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .kerning(1.5)
                            .foregroundStyle(.textSecondary)
                    }
                }

                VStack(spacing: 6) {
                    Text("Completed with discipline and faith")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundStyle(.textPrimary)
                    Text("No missed day. Pure intention. Strong heart.")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.textSecondary)
                }
                .multilineTextAlignment(.center)

                HStack(spacing: 10) {
                    capsuleStat(title: "Days", value: "\(totalDays)/\(totalDays)")
                    capsuleStat(title: "Result", value: "Perfect")
                }
                .padding(.top, 2)

                Text(completionDate.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .kerning(1.5)
                    .foregroundStyle(.textSecondary)

                VStack(spacing: 4) {
                    Text("PROUD KOE NA WIN PRACTITIONER")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .kerning(1.3)
                        .foregroundStyle(.textSecondary)

                    Text("koenawin.app")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
        .clipShape(.rect(cornerRadius: 34))
    }

    private func capsuleStat(title: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption2)
                .fontWeight(.bold)
                .kerning(1.3)
                .foregroundStyle(.textSecondary)
            Text(value)
                .font(.footnote)
                .fontWeight(.heavy)
                .foregroundStyle(.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.appBackground)
        .clipShape(.capsule)
    }
}

extension AchievementScreen {
    private var achievementBadgeExport: some View {
        badgeCard
            .padding(.horizontal)
            .background(backgroundGradient.ignoresSafeArea())
    }

    private func generateBadgeImage() {
        isGenerating = true
        defer { isGenerating = false }

        let exportView = AchievementBadgeCard(totalDays: 81, completionDate: journeyService.activeJourney?.endDate?.toStringWith(format: .yyyy_MMMM_d) ?? "")

        let renderer = ImageRenderer(content: exportView)
        renderer.scale = UIScreen.current?.scale ?? 1

        guard let uiImage = renderer.uiImage, let data = uiImage.pngData() else {
            return
        }

        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("koenawin-achievement-\(UUID().uuidString).png")

        do {
            try data.write(to: fileURL)
            exportedBadgeURL = fileURL
            exportedPreviewImage = uiImage
        } catch {
            print("Failed to write share badge image: \(error)")
        }
    }
}

struct AchievementExport: View {
    var body: some View {
        AchievementBadgeCard(
            totalDays: max(81, 81),
            completionDate: Date.today().toStringWith(format: .yyyy_MMMM_d)
        )
        .padding()
        .background(backgroundGradient.ignoresSafeArea())
    }
}

private extension View {
    var backgroundGradient: some View {
        ZStack {
            Color(.appBackground)

            Circle()
                .fill(.accent.opacity(0.08))
                .frame(width: 280, height: 280)
                .blur(radius: 2)
                .offset(x: 110, y: -300)

            Circle()
                .fill(.accent.opacity(0.06))
                .frame(width: 220, height: 220)
                .blur(radius: 4)
                .offset(x: -140, y: 360)
        }
    }
}

#Preview {
    AchievementScreen()
        .previewEnviroments()
}
