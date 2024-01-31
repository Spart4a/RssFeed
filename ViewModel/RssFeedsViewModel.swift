//
//  RssFeedsViewModel.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import Combine
import SwiftUI
import FeedKit

class RssFeedsViewModel: ObservableObject {
    private let dataService: FeedDataManager
    private var subscriptions = Set<AnyCancellable>()

    @Published var displayArchivedFeeds: Bool = false
    @Published var notificationManager: NotificationManager

    @Published var allFeeds = [RssFeed]()
    @Published var archivedFeeds = [RssFeed]()
    @Published var feedItems = [FeedItem]()

    @Published var currentFeed: FeedViewModel? = nil
    @Published var currentItem: FeedItemDataModel? = nil

    var activeFeeds: [RssFeed] {
        self.displayArchivedFeeds ? self.archivedFeeds : self.allFeeds
    }

    var pageTitle: String {
        self.displayArchivedFeeds ? "Your Saved RSS Feeds" : "All RSS Feeds"
    }

    var emptyStateMessage: String {
        self.displayArchivedFeeds ? "You don't have any saved RSS feeds." : "There are no new RSS feeds available."
    }

    init(repository: FeedDataManager = RealmFeedsManager(), notificationManager: NotificationManager = .init()) {
        self.dataService = repository
        self.notificationManager = notificationManager
        observeDataUpdates()
        fetchArchivedFeeds()
    }
    
    private func observeDataUpdates() {
        dataService.observeDatabaseChanges()
            .sink { [weak self] _ in
                self?.fetchArchivedFeeds()
            }
            .store(in: &subscriptions)
    }

    private func fetchArchivedFeeds() {
        dataService.fetchStoredFeeds()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Initial get saved feeds error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] feeds in
                self?.organizeFeeds(feeds)
            }
            .store(in: &subscriptions)
    }

    private func organizeFeeds(_ savedFeeds: [RssFeed]) {
        let sortedFeeds = allFeeds.sorted { $0.isFavorite && !$1.isFavorite }
        let savedFeedsSorted = savedFeeds.filter({$0.isArchive})
                                         .sorted { $0.isFavorite && !$1.isFavorite }

        let feeds = sortedFeeds.filter { feed in
            !savedFeedsSorted.contains(where: {$0 == feed})
        }

        withAnimation(.spring()) {
            self.allFeeds = feeds
            self.archivedFeeds = savedFeedsSorted
        }
    }

    func removeFeed(_ feed: RssFeed) {
        if feed.isArchive && displayArchivedFeeds {
            dataService.deleteFeed(feed)
        }

        allFeeds.removeAll(where: {$0 == feed})
        displaySuccessNotification(with: "The RSS feed has been successfully removed.")
    }

    func toggleFeedArchiveStatus(_ feed: RssFeed) {
        let isArchive = feed.isArchive
        let toastMessage = isArchive ? "The RSS feed has been removed from your saved list." : "The RSS feed has been added to your saved list."

        if feed.isArchive {
            allFeeds.append(feed)
        }

        displaySuccessNotification(with: toastMessage)
        dataService.toggleFeedArchiveStatus(feed)
    }

    func toggleFavoriteStatus(_ feed: RssFeed) {
        dataService.toggleFavoriteStatus(feed)
    }

    private func displaySuccessNotification(with message: String) {
        notificationManager.showSuccessToast(withMessage: message)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.notificationManager.showSucces()
        })
    }

    private func displayErrorNotification(with message: String) {
        notificationManager.showErrorToast(withMessage: message)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.notificationManager.showError()
        })
    }

    func getFeed(from urlString: String, callback: @escaping () -> ()) {
        let urlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        if urlString.isEmpty {
            displayErrorNotification(with: "Please enter a valid URL to fetch the RSS feed.")
            return
        }

        getRssFeed(from: urlString, callback: callback)
    }

    func getFeedItems(from feed: Feed) {
        switch feed {
        case .atom(let atomFeed):
            for item in atomFeed.entries ?? [] {
                feedItems.append(item.toRssFeedItem())
            }
        case .json(let jsonFeed):
            for item in jsonFeed.items ?? [] {
                feedItems.append(item.toRssFeedItem())
            }
        case .rss(let rssFeed):
            for item in rssFeed.items ?? [] {
                feedItems.append(item.toRssFeedItem())
            }
        }
    }

    func getRssFeed(from urlString: String, getRssFeedItems: Bool = false, callback: @escaping () -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }

        notificationManager.showLoadingToast()
        dataService.fetchFeed(from: url)
            .sink { completion in
                switch completion {
                case .finished:
                    callback()
                    if getRssFeedItems {
                        self.notificationManager.isShowingLoadingToast = false
                    } else {
                        self.displaySuccessNotification(with: "New RSS feed successfully added.")
                    }
                case .failure:
                    self.displayErrorNotification(with: "Unable to find an RSS feed at the provided URL. Please check the URL and try again.")
                }
            } receiveValue: { [weak self] feed in
                if getRssFeedItems {
                    self?.getFeedItems(from: feed)
                } else {
                    self?.appendRssFeed(from: feed, url: url)
                }
            }
            .store(in: &subscriptions)
    }

    func appendRssFeed(from feed: Feed, url: URL) {
        let rssFeed = RssFeed()
        rssFeed.urlString = url.absoluteString

        func updateFeedProperties(title: String?, desc: String?, imageUrl: String?) {
            rssFeed.title = title ?? ""
            rssFeed.desc = desc?.removingNewLines ?? ""
            rssFeed.imageString = imageUrl ?? ""
        }

        switch feed {
        case .atom(let atomFeed):
            let imageUrl = (atomFeed.id.map { (URL(string: $0)?.appendingPathComponent(atomFeed.icon ?? ""))! })?.absoluteString
            updateFeedProperties(title: atomFeed.title, desc: nil, imageUrl: imageUrl)
        case .json(let jsonFeed):
            updateFeedProperties(title: jsonFeed.title, desc: jsonFeed.description, imageUrl: jsonFeed.icon)
        case .rss(let _rssFeed):
            updateFeedProperties(title: _rssFeed.title, desc: _rssFeed.description, imageUrl: _rssFeed.image?.url)
        }

        let responseMessage = allFeeds.contains(where: {$0.urlString == rssFeed.urlString}) ? "Existing RSS feed updated with new information." : "RSS feed added"

        withAnimation(.spring()) {
            allFeeds.removeAll(where: {$0.urlString == rssFeed.urlString})
            allFeeds.append(rssFeed)
        }

        displaySuccessNotification(with: responseMessage)
    }
}

    

