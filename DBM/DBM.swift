//
//  DBM.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import RealmSwift

class DBM {
    static let DB_VERSION: UInt64 = 1
    
    static func setup() {
        let path = "RssFeed"
        var config = Realm.Configuration.defaultConfiguration
        
        //path setup
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(path)
        config.fileURL!.appendPathExtension("realm")
        
        config.deleteRealmIfMigrationNeeded = true
        
        //set schema version for versioning purposes
        config.schemaVersion = DB_VERSION
        Realm.Configuration.defaultConfiguration = config
    }
}
