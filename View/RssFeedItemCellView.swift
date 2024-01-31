//
//  RssFeedItemCellView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

struct FeedItemCell: View {
    @EnvironmentObject private var feedViewModel: RssFeedsViewModel
    let item: FeedItem

    var body: some View {
        Button(action: { feedViewModel.currentItem = FeedItemDataModel(feedItem: item) }) {
            cellContent
        }
        .listRowSeparator(.visible)
        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
    }

    private var cellContent: some View {
        HStack(spacing: 10) {
            feedImage
            feedDetails
        }
        .padding(10)
    }

    private var feedImage: some View {
        Group {
            if let url = URL(string: item.imageString) {
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

    private var feedDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(item.summary.removingHTMLTags.removingNewLines)
                .font(.subheadline)
                .lineLimit(3)
                .foregroundStyle(.secondary)
        }
    }
}

