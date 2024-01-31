//
//  RssFeedApp.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

@main
struct RssFeedApp: App {
    var body: some Scene {
        WindowGroup {
            MainRssFeedView()
                .onAppear {
                    DBM.setup()
                }
        }
    }
}
