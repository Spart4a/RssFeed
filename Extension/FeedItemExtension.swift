//
//  FeedItemExtension.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import FeedKit

protocol RSSItemConvertible {
    func toRssFeedItem() -> RssFeedItem
}

extension RSSFeedItem: RSSItemConvertible {
    func toRssFeedItem() -> RssFeedItem {
        return RssFeedItem.create(
            title: title ?? "",
            desc: description ?? "",
            urlString: link ?? "",
            createdTime: pubDate ?? Date()
        )
    }
}

extension AtomFeedEntry: RSSItemConvertible {
    func toRssFeedItem() -> RssFeedItem {
        return RssFeedItem.create(
            title: title ?? "",
            desc: "",
            urlString: links?.first?.attributes?.href ?? "",
            createdTime: (published ?? updated) ?? Date()
        )
    }
}

extension JSONFeedItem: RSSItemConvertible {
    func toRssFeedItem() -> RssFeedItem {
        return RssFeedItem.create(
            title: title ?? "",
            urlString: url ?? "",
            imageString: image ?? "",
            createdTime: datePublished ?? Date()
        )
    }
}
