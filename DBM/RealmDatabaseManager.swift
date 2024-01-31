//
//  RealmDatabaseManager.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import RealmSwift

class RealmDatabaseManager {
    static let databaseVersion: UInt64 = 1

    static func setup() {
        let databaseName = "RssFeed"

        guard var configurationURL = Realm.Configuration.defaultConfiguration.fileURL else {
            print("Error: Unable to find default Realm configuration file URL.")
            return
        }

        configurationURL.deleteLastPathComponent()
        configurationURL.appendPathComponent(databaseName)
        configurationURL.appendPathExtension("realm")

        var configuration = Realm.Configuration.defaultConfiguration
        configuration.fileURL = configurationURL

        configuration.deleteRealmIfMigrationNeeded = true

        
        configuration.schemaVersion = databaseVersion

       
        Realm.Configuration.defaultConfiguration = configuration
    }
}

