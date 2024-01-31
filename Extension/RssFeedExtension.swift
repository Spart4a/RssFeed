//
//  RssFeedExtension.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import FeedKit

protocol RSSItemConvertable {
    func asRSSItem() -> RssFeedItem
}

extension RSSFeedItem: RSSItemConvertable {
    func asRSSItem() -> RssFeedItem {
        return RssFeedItem.create(
            title: title ?? "",
            desc: description ?? "",
            urlString: link ?? "",
            createdTime: pubDate ?? Date()
        )
    }
}

extension AtomFeedEntry: RSSItemConvertable {
    func asRSSItem() -> RssFeedItem {
        return RssFeedItem.create(
            title: title ?? "",
            desc: "",
            urlString: links?.first?.attributes?.href ?? "",
            createdTime: (published ?? updated) ?? Date()
        )
    }
}

extension JSONFeedItem: RSSItemConvertable {
    func asRSSItem() -> RssFeedItem {
        return RssFeedItem.create(
            title: title ?? "",
            urlString: url ?? "",
            imageString: image ?? "",
            createdTime: datePublished ?? Date()
        )
    }
}
