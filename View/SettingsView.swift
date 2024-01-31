//
//  OptionView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appSettings: UserPreferences

    var body: some View {
        VStack(spacing: 15) {
            safariToggle
            darkModeToggle
        }
        .padding()
        .preferredColorScheme(appSettings.enableDarkMode ? .dark : .light)
    }

    private var safariToggle: some View {
        Toggle("Open RSS Items in Safari", isOn: $appSettings.useSafariForLinks)
            .bold()
    }

    private var darkModeToggle: some View {
        Toggle("Enable Dark Mode", isOn: $appSettings.enableDarkMode)
            .bold()
    }
}


