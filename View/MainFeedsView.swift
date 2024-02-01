//
//  MainView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

struct MainFeedsView: View {
    @StateObject var feedsViewModel: FeedsViewModel
    @StateObject private var userPreferences = UserPreferences.shared
    
    init() {
        _feedsViewModel = StateObject(wrappedValue: .init())
    }
    
    var body: some View {
        TabView {
            FeedListView()
                .onAppear { feedsViewModel.displayArchivedFeeds = false }
                .tabItem {
                    Label("Latest", systemImage: "newspaper")
                }
            
            FeedListView()
                .onAppear { feedsViewModel.displayArchivedFeeds = true }
                .badge(feedsViewModel.archivedFeeds.count)
                .tabItem {
                    Label("Archived", systemImage: "square.and.arrow.down.fill")
                }
        }
        .preferredColorScheme(userPreferences.enableDarkMode ? .dark : .light)
        .environmentObject(feedsViewModel)
        .environmentObject(userPreferences)
        .tint(.blue)
    }
}

//#Preview {
//    MainView()
//}
