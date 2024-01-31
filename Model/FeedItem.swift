//
//  FeedItem.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import RealmSwift

public final class FeedItem: Object {
    @Persisted(primaryKey: true) var identifier: UUID = UUID()
    @Persisted var creationDate: Date?
    @Persisted var summary: String
    @Persisted var title: String
    @Persisted var urlString: String
    @Persisted var imageString: String
    
    static func create(title: String = "", desc: String = "", urlString: String = "", imageString: String = "", creationDate: Date = Date()) -> FeedItem {
        let feedItem = FeedItem()
        feedItem.title = title
        feedItem.summary = desc
        feedItem.urlString = urlString
        feedItem.creationDate = creationDate
        feedItem.imageString = imageString
        return feedItem
     }
}
