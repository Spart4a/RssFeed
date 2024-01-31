//
//  RssFeedDTO.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation

class RssFeedDTO: Identifiable {
    var id: UUID
    var rssFeed: RssFeed
    
    init(id: UUID = .init(), rssFeed: RssFeed) {
        self.id = id
        self.rssFeed = rssFeed
    }
}
