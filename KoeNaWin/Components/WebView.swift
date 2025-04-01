//
//  WebView.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-31.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: String

    func makeUIView(context _: Context) -> some UIView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        return webview
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}
