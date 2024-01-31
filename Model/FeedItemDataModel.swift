//
//  RssFeedItemDTO.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation

class FeedItemDataModel: Identifiable {
    var id: UUID
    var feedItem: FeedItem
    
    init(id: UUID = UUID(), feedItem: FeedItem) {
        self.id = id
        self.feedItem = feedItem
    }
}
