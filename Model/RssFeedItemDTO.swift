//
//  RssFeedItemDTO.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation

class RssFeedItemDTO: Identifiable {
    var id: UUID
    var rssFeedItem: RssFeedItem
    
    init(id: UUID = .init(), rssFeedItem: RssFeedItem) {
        self.id = id
        self.rssFeedItem = rssFeedItem
    }
}
