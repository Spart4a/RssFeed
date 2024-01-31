//
//  RssFeedApp.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

@main
struct RSSFeedApp: App {
    var body: some Scene {
        WindowGroup {
            RSSFeedMainView()
                .onAppear {
                    RealmDatabaseManager.setup()
                }
        }
    }
}
