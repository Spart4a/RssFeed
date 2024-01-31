//
//  ViewModel.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import FeedKit
import Combine
import SwiftUI

class RssFeedsViewModel: ObservableObject {
    private let repository: RssFeedsProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var showSavedFeeds: Bool = false
    @Published var toastManager: ToastManager
    
    @Published var feeds = [RssFeed]()
    @Published var savedFeeds = [RssFeed]()
    @Published var rssFeedItems = [RssFeedItem]()
    
    @Published var selectedFeed: RssFeedDTO? = nil
    @Published var selectedRssItem: RssFeedItemDTO? = nil
    
    var rssFeeds: [RssFeed] {
        self.showSavedFeeds ? self.savedFeeds : self.feeds
    }
    
    var navigationTitle: String {
        self.showSavedFeeds ? "Saved RSS feeds" : "RSS feeds"
    }
    
    var backgroundTitle: String {
        self.showSavedFeeds ? "No saved RSS feeds" : "No new RSS feeds"
    }
    
    init(repository: RssFeedsProtocol = RssFeedRepository(), toastManager: ToastManager = .init()) {
        self.repository = repository
        self.toastManager = toastManager
        self.observeDatabaseChanges()
        self.getSavedFeeds()
    }
}

extension RssFeedsViewModel {
    private func observeDatabaseChanges() {
        self.repository.observeDatabaseChanges()
            .sink { [weak self] _ in
                self?.getSavedFeeds()
            }
            .store(in: &cancellables)
    }
    
    private func getSavedFeeds() {
        self.repository.getSavedFeeds()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Initial get saved feeds error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] feeds in
                self?.filterFeeds(feeds)
            }
            .store(in: &cancellables)
    }
    
    private func filterFeeds(_ savedFeeds: [RssFeed]) {
        var feeds = self.feeds
            .sorted(by: {
                $0.createdTime < $1.createdTime
            })
            .sorted(by: {
                $0.isFavorite && !$1.isFavorite
            })
        
        let savedFeeds = savedFeeds
            .filter({$0.isArchive})
            .sorted(by: {
                $0.createdTime < $1.createdTime
            })
            .sorted(by: {
                $0.isFavorite && !$1.isFavorite
            })
        
        feeds.removeAll { feed in
            savedFeeds.contains(where: {$0 == feed})
        }
        
        withAnimation(.spring()) {
            self.feeds = feeds
            self.savedFeeds = savedFeeds
        }
    }
}

extension RssFeedsViewModel {
    func deleteFeed(_ feed: RssFeed) {
        if feed.isArchive && self.showSavedFeeds {
            self.repository.deleteFeed(feed)
        }
        
        self.feeds.removeAll(where: {$0 == feed})
        self.showSuccesToast(with: "RSS feed deleted")
    }
    
    func saveOrReturnFeed(_ feed: RssFeed) {
        let isArchive = feed.isArchive
        let toastMessage = isArchive ? "RSS feed unsaved" : "RSS feed saved"
        
        if feed.isArchive {
            self.feeds.append(feed)
        }
        
        self.showSuccesToast(with: toastMessage)
        self.repository.saveOrRemoveFeed(feed)
    }
    
    func makeOrRemoveFavorite(_ feed: RssFeed) {
        self.repository.makeOrRemoveFavorite(feed)
    }
    
    private func showSuccesToast(with message: String) {
        self.toastManager.showSuccessToast(withMessage: message)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.toastManager.showSucces()
        })
    }
    
    private func showErrorToast(with message: String) {
        self.toastManager.showErrorToast(withMessage: message)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.toastManager.showError()
        })
    }
}

extension RssFeedsViewModel {
    func getFeed(from urlString: String, callback: @escaping () -> ()) {
        let urlString = urlString.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        if urlString.isEmpty {
            self.showErrorToast(with: "Please enter URL")
            return
        }
        
        self.getRssFeed(from: urlString, callback: callback)
    }
    
    func getFeedItems(from feed: Feed) {
        switch feed {
        case .atom(let atomFeed):
            for item in atomFeed.entries ?? [] {
                self.rssFeedItems.append(item.asRSSItem())
            }
        case .json(let jsonFeed):
            for item in jsonFeed.items ?? [] {
                self.rssFeedItems.append(item.asRSSItem())
            }
        case .rss(let rssFeed):
            for item in rssFeed.items ?? [] {
                self.rssFeedItems.append(item.asRSSItem())
            }
        }
    }
}

extension RssFeedsViewModel {
    func getRssFeed(
        from urlString: String,
        getRssFeedItems: Bool = false,
        callback: @escaping () -> ()
    ) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        self.toastManager.showLoadingToast()
        self.repository.getFeed(from: url)
            .sink { completion in
                switch completion {
                case .finished:
                    callback()
                    if getRssFeedItems {
                        self.toastManager.isShowingLoadingToast = false
                    } else {
                        self.showSuccesToast(with: "RSS feed added successfully")
                    }
                case .failure:
                    self.showErrorToast(with: "No RSS feed with that URL")
                }
            } receiveValue: { [weak self] feed in
                if getRssFeedItems {
                    self?.getFeedItems(from: feed)
                } else {
                    self?.appendRssFeed(from: feed, url: url)
                }
            }
            .store(in: &cancellables)
    }
    
    func appendRssFeed(from feed: Feed, url: URL) {
        let rssFeed = RssFeed()
        rssFeed.urlString = url.absoluteString
        
        switch feed {
        case .atom(let atomFeed):
            rssFeed.title = atomFeed.title ?? ""
            if let id = atomFeed.id,
               var url = URL(string: id),
               let icon = atomFeed.icon {
                
                url.appendPathComponent(icon)
                rssFeed.imageString = url.absoluteString
            }
            
        case .json(let jsonFeed):
            rssFeed.title = jsonFeed.title ?? ""
            rssFeed.desc = jsonFeed.description?.trimWhiteAndSpace ?? ""
            rssFeed.imageString = jsonFeed.icon ?? ""
            
        case .rss(let _rssFeed):
            rssFeed.title = _rssFeed.title ?? ""
            rssFeed.desc = _rssFeed.description?.trimWhiteAndSpace ?? ""
            rssFeed.imageString = _rssFeed.image?.url ?? ""
        }
        
        var responseMessage = "RSS feed added"
        
        //replace with new RSS feed
        if let rssFeed = self.feeds.first(
            where: {$0.urlString == rssFeed.urlString}
        ) {
            self.feeds.removeAll(where: {$0 == rssFeed})
            responseMessage = "RSS feed replaced"
        }
        
        self.showSuccesToast(with: responseMessage)
        
        withAnimation(.spring()) {
            self.feeds.append(rssFeed)
        }
    }
}
