//
//  UserPreferences.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation

class UserPreferences: ObservableObject {
    static let shared = UserPreferences()
    
    @Published var useSafariForLinks: Bool {
        didSet {
            UserDefaults.standard.set(useSafariForLinks, forKey: "useSafariForLinks")
        }
    }
    
    @Published var enableDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(enableDarkMode, forKey: "enableDarkMode")
        }
    }
    
    private init() {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "hasLaunchedBefore") == nil {
            // First launch of the app
            defaults.set(false, forKey: "enableDarkMode")
            defaults.set(false, forKey: "useSafariForLinks")
            defaults.set(true, forKey: "hasLaunchedBefore")
        }
        
        self.useSafariForLinks = defaults.bool(forKey: "useSafariForLinks")
        self.enableDarkMode = defaults.bool(forKey: "enableDarkMode")
    }
}
