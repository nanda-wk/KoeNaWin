//
//  Router.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    @AppStorage("selectedTab") var selectedTab: TabItem = .home

    @Published private var paths: [TabItem: [RouterDestination]] = [:]

    @Published var presentedSheet: RouterSheet?

    subscript(tab: TabItem) -> [RouterDestination] {
        get { paths[tab] ?? [] }
        set { paths[tab] = newValue }
    }

    func navigateTo(_ destination: RouterDestination, for tab: TabItem? = nil) {
        let targetTab = tab ?? selectedTab
        if paths[targetTab] == nil {
            paths[targetTab] = [destination]
        } else {
            paths[targetTab]?.append(destination)
        }
    }

    func popToRoot(for tab: TabItem? = nil) {
        paths[tab ?? selectedTab] = []
    }

    func popNavigation(for tab: TabItem? = nil) {
        let targetTab = tab ?? selectedTab
        if paths[targetTab]?.isEmpty == false {
            paths[targetTab]?.removeLast()
        }
    }

    func presentSheet(_ sheet: RouterSheet) {
        presentedSheet = sheet
    }

    func dismissSheet() {
        presentedSheet = nil
    }
}
