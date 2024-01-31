//
//  RssFeedItemsView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

struct FeedItemsListView: View {
    @EnvironmentObject private var feedViewModel: RssFeedsViewModel
    let feed: RssFeed

    var body: some View {
        VStack {
            feedItemList
        }
        .onAppear(perform: loadFeedItems)
        .onDisappear(perform: clearFeedDetails)
        .sheet(item: $feedViewModel.currentItem, content: sheetContent)
    }

    private var feedItemList: some View {
        List(feedViewModel.feedItems, id: \.self) { item in
            FeedItemCell(item: item)
        }
        .listStyle(.plain)
    }

    private func loadFeedItems() {
        feedViewModel.getRssFeed(
            from: feed.urlString,
            getRssFeedItems: true,
            callback: {}
        )
    }

    private func clearFeedDetails() {
        feedViewModel.currentFeed = nil
        feedViewModel.currentItem = nil
    }

    private func sheetContent(for item: RssFeedItemDTO) -> some View {
        if AppEnvironment.shared.useSafari, let url = URL(string: item.rssFeedItem.urlString) {
            return AnyView(SafariBrowserView(url: url))
        } else {
            return AnyView(webView(urlString: item.rssFeedItem.urlString))
        }
    }


    private func webView(urlString: String) -> some View {
        NavigationView {
            WebView(urlString: urlString)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { feedViewModel.currentItem = nil }) {
                            Text("Close")
                                .foregroundStyle(.blue)
                                .bold()
                        }
                    }
                }
        }
    }
}

// Preview provider omitted for brevity
