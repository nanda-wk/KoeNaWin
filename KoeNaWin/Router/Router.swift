//
//  Router.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Foundation

final class Router: ObservableObject {
    @Published var path: [RouterDestination] = []

    func navigate(to destination: RouterDestination) {
        path.append(destination)
    }
}
