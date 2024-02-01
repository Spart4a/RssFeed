//
//  WebContentView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI
import WebKit

struct WebContentView: UIViewRepresentable {
    let urlString: String

    // Create the WKWebView instance
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.bounces = false
        loadRequest(in: webView)
        return webView
    }


    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }


    private func loadRequest(in webView: WKWebView) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }


    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebContentView

        init(_ parent: WebContentView) {
            self.parent = parent
        }
    }
}

