//
//  RssFeedApp.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

@main
struct RSSFeedApp: App {
    @StateObject private var userPreferences = UserPreferences.shared

    var body: some Scene {
           WindowGroup {
               MainFeedsView()
                   .environmentObject(userPreferences)
                   .preferredColorScheme(userPreferences.enableDarkMode ? .dark : .light)
                   .onAppear {
                       RealmDatabaseManager.setup()
                   }
           }
    }
}
