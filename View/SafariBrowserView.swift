//
//  SafariView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//


import SwiftUI
import SafariServices

struct SafariBrowserView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        return SFSafariViewController(url: url, configuration: config)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
      }
  }
