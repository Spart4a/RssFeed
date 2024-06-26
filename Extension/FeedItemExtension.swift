//
//  FeedItemExtension.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import FeedKit

protocol RSSItemConvertible {
    func toRssFeedItem() -> FeedItem
}

extension RSSFeedItem: RSSItemConvertible {
    func toRssFeedItem() -> FeedItem {
        return FeedItem.create(
            title: title ?? "",
            desc: description ?? "",
            urlString: link ?? "",
            creationDate: pubDate ?? Date()
        )
    }
}

extension AtomFeedEntry: RSSItemConvertible {
    func toRssFeedItem() -> FeedItem {
        return FeedItem.create(
            title: title ?? "",
            desc: "",
            urlString: links?.first?.attributes?.href ?? "",
            creationDate: (published ?? updated) ?? Date()
        )
    }
}

extension JSONFeedItem: RSSItemConvertible {
    func toRssFeedItem() -> FeedItem {
        return FeedItem.create(
            title: title ?? "",
            urlString: url ?? "",
            imageString: image ?? "",
            creationDate: datePublished ?? Date()
        )
    }
}
