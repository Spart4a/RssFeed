//
//  RSSFeedService.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import Combine
import FeedKit

class RSSFeedService {
    static func fetchRSSFeed(url: URL,
                     completionHandler: @escaping ((Result<Feed, Error>) -> Void)) {
        
        let parser = FeedParser(URL: url)
        parser.parseAsync(queue: DispatchQueue.global()) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    completionHandler(.success(feed))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
