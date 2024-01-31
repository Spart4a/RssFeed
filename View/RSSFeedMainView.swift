//
//  MainView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

struct RSSFeedMainView: View {
    @StateObject var rssFeedsViewModel: RssFeedsViewModel
    @StateObject private var appSettings = UserPreferences.shared
    
    init() {
        _rssFeedsViewModel = StateObject(wrappedValue: .init())
    }
    
    var body: some View {
        TabView {
            RSSFeedListView()
                .onAppear { rssFeedsViewModel.displayArchivedFeeds = false }
                .tabItem {
                    Label("Latest", systemImage: "newspaper")
                }
            
            RSSFeedListView()
                .onAppear { rssFeedsViewModel.displayArchivedFeeds = true }
                .badge(rssFeedsViewModel.archivedFeeds.count)
                .tabItem {
                    Label("Archived", systemImage: "square.and.arrow.down.fill")
                }
        }
        .preferredColorScheme(appSettings.enableDarkMode ? .dark : .light)
        .environmentObject(rssFeedsViewModel)
        .environmentObject(appSettings)
        .tint(.blue)
    }
}

//#Preview {
//    MainView()
//}
