//
//  RssRepository.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import Combine
import RealmSwift
import FeedKit

protocol RSSFeedDataManaging {
    func monitorDatabaseChanges() -> AnyPublisher<Void, Never>
    func retrieveStoredFeeds() -> AnyPublisher <[RssFeed], NetworkError>
    func getFeed(from url: URL) -> AnyPublisher <Feed, NetworkError>
    func makeOrRemoveFavorite(_ feed: RssFeed)
    func deleteFeed(_ feed: RssFeed)
    func saveOrRemoveFeed(_ feed: RssFeed)
    func removeDatabaseObserver()
}

class RealmFeedDataService: RSSFeedDataManaging {
    private var realm: Realm?
    private var notificationToken: NotificationToken?
    
    private let databaseChangesSubject = PassthroughSubject<Void, Never>()
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            print("Initial realm error: \(error.localizedDescription)")
        }
    }
    
    deinit {
        self.removeDatabaseObserver()
        self.deleteFeeds()
    }
}

extension RealmFeedDataService {
    func monitorDatabaseChanges() -> AnyPublisher<Void, Never> {
        guard let realm = self.realm else {
            return Empty<Void, Never>()
                .eraseToAnyPublisher()
        }
        
        let feeds: Results<RssFeed> = realm.objects(RssFeed.self)
        self.notificationToken = feeds.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                print("initial load")
            case .update:
                self?.databaseChangesSubject.send()
            case .error(let error):
                print("\(error)")
            }
        }
        
        return databaseChangesSubject.eraseToAnyPublisher()
    }
    
    func removeDatabaseObserver() {
        notificationToken?.invalidate()
    }
    
    func retrieveStoredFeeds() -> AnyPublisher<[RssFeed], NetworkError> {
        guard let realm = realm else {
            return Fail(error: NetworkError.databaseError)
                .eraseToAnyPublisher()
        }
        
        let savedFeeds = Array(realm.objects(RssFeed.self))
            .filter({
                !$0.isDeleted &&
                ($0.isFavorite ||
                 $0.isArchive)
            })
        
        return Just(savedFeeds)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func getFeed(from url: URL) -> AnyPublisher<Feed, NetworkError> {
        return Future<Feed, NetworkError> { promise in
            ApiService.fetchNewRSS(
                url: url) { results in
                    switch results {
                    case .success(let feed):
                        promise(.success(feed))
                    case .failure(let failure):
                        promise(.failure(NetworkError.errorMessage(
                            failure.localizedDescription)
                        ))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteFeeds() {
        guard let realm = realm else {
            return
        }
        
        let deleteFeeds = realm.objects(RssFeed.self)
            .filter({$0.isDeleted})
        
        try? realm.write({
            realm.delete(deleteFeeds)
        })
    }
    
    func retrieveArchivedFeeds() -> AnyPublisher<[RssFeed], NetworkError> {
        guard let realm = realm else {
            return Fail(error: NetworkError.databaseError)
                .eraseToAnyPublisher()
        }

        let archivedFeeds = Array(realm.objects(RssFeed.self))
            .filter({ $0.isArchive && !$0.isDeleted })

        return Just(archivedFeeds)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func makeOrRemoveFavorite(_ feed: RssFeed) {
        guard let realm = realm else {
            return
        }
        
        let isFavorite = feed.isFavorite
        
        try? realm.write({
            feed.isFavorite = isFavorite ? false : true
            realm.add(feed, update: .all)
        })
    }
    
    func saveOrRemoveFeed(_ feed: RssFeed) {
        guard let realm = realm else {
            return
        }
        
        let isArchive = feed.isArchive
        
        try? realm.write({
            feed.isArchive = isArchive ? false : true
            realm.add(feed, update: .all)
        })
    }
    
    func deleteFeed(_ feed: RssFeed) {
        guard let realm = realm else {
            return
        }
        
        try? realm.write({
            feed.isDeleted = true
        })
    }
}
