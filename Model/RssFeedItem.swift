//
//  RssFeedItem.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import RealmSwift

public final class RssFeedItem: Object {
    @Persisted(primaryKey: true) var id: UUID = .init()
    @Persisted var createdTime: Date?
    @Persisted var desc: String
    @Persisted var title: String
    @Persisted var urlString: String
    @Persisted var imageString: String
    
    static func create(title: String = "", desc: String = "", urlString: String = "", imageString: String = "", createdTime: Date = Date()) -> RssFeedItem {
       let item = RssFeedItem()
       item.title = title
       item.desc = desc
       item.urlString = urlString
       item.createdTime = createdTime
       item.imageString = imageString
       return item
     }
}
