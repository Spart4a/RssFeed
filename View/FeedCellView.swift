//
//  RssFeedCellView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

struct FeedCellView: View {
    @EnvironmentObject private var feedViewModel: RssFeedsViewModel
    
    let feed: RssFeed

    var body: some View {
        Button(action: { feedViewModel.currentFeed = RssFeedDTO(rssFeed: feed) }) {
            cellContent
        }
        .listRowSeparator(.visible)
        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .swipeActions(allowsFullSwipe: false) {
            deleteButton
            archiveToggleButton
        }
    }

    private var cellContent: some View {
        HStack(spacing: 10) {
            feedImage
            feedInfo
        }
        .padding(10)
    }

    private var feedImage: some View {
        Group {
            if let url = URL(string: feed.imageString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                         .scaledToFit()
                         .clipShape(RoundedRectangle(cornerRadius: 10))
                         .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView().frame(width: 50, height: 50)
                }
            }
        }
    }

    private var feedInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            titleAndFavoriteButton
            descriptionText
        }
    }

    private var titleAndFavoriteButton: some View {
        HStack {
            Text(feed.title)
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            favoriteButton
        }
    }

    private var favoriteButton: some View {
        Button(action: { feedViewModel.toggleFavoriteStatus(feed) }) {
            Image(systemName: "star.fill")
                .foregroundStyle(feed.isFavorite ? .yellow : .gray)
        }
    }

    private var descriptionText: some View {
        Text(feed.desc.removingHTMLTags.removingNewLines) 
            .font(.subheadline)
            .lineLimit(3)
            .foregroundStyle(.secondary)
    }


    private var deleteButton: some View {
        Button(role: .destructive) {
            feedViewModel.removeFeed(feed)
        } label: {
            Image(systemName: "trash.fill")
        }
        .tint(.red)
    }

    private var archiveToggleButton: some View {
        Button(action: { feedViewModel.toggleFeedArchiveStatus(feed) }) {
            Image(systemName: archiveToggleImageName)
        }
        .tint(.blue)
    }

    private var archiveToggleImageName: String {
        feed.isArchive ? "arrow.uturn.down.square.fill" : "arrow.down.to.line.square.fill"
    }
}


