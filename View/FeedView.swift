//
//  FeedView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI
import AlertToast

struct FeedListView: View {
    @EnvironmentObject private var FeedViewModel: FeedsViewModel
    @EnvironmentObject private var appSettings: UserPreferences
    
    @State private var showingAddFeedView: Bool = false
    @State private var showingSettingsView: Bool = false
    
    private let successNotificationDuration: Double = 3.0
    private let errorNotificationDuration: Double = 4
    
    var body: some View {
        NavigationView {
            VStack {
                List(FeedViewModel.activeFeeds, id: \.self) { feed in
                    FeedCellView(feed: feed)
                }
                .environmentObject(FeedViewModel)
                .listStyle(.plain)
            }
            .navigationTitle(FeedViewModel.pageTitle)
            .navigationBarTitleDisplayMode(.inline)
            .background(
                EmptyStateView(
                    isEmpty: FeedViewModel.activeFeeds.isEmpty,
                    message: FeedViewModel.emptyStateMessage)
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettingsView.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .foregroundStyle(.blue)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                AddButtonView(isPressed: $showingAddFeedView)
                    .padding()
            }
            .toast(isPresenting: $FeedViewModel.notificationManager.isShowingSuccessToast, duration: successNotificationDuration) {
                AlertToast(displayMode: .banner(.pop), type: .complete(.green), title: FeedViewModel.notificationManager.successToastMessage)
            }
            .toast(isPresenting: $FeedViewModel.notificationManager.isShowingLoadingToast, duration: successNotificationDuration) {
                AlertToast(type: .loading)
            }
            .toast(isPresenting: $FeedViewModel.notificationManager.isShowingErrorToast, duration: errorNotificationDuration) {
                AlertToast(displayMode: .banner(.pop), type: .error(.red), title: FeedViewModel.notificationManager.errorToastMessage, style: .style(titleColor: .red,titleFont: .body, subTitleFont: .body))
            }
            .onAppear {
                self.showingSettingsView = false
                self.showingAddFeedView = false
            }
        }
        .sheet(isPresented: $showingAddFeedView, content: {
            AddFeedView()
                .environmentObject(FeedViewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(150)])
        })
        .sheet(isPresented: $showingSettingsView, content: {
            SettingsView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(150)])
                .environmentObject(appSettings)
        })
        .sheet(item: $FeedViewModel.currentFeed) { feed in
            FeedItemsListView(feed: feed.rssFeed)
                .environmentObject(FeedViewModel)
                .presentationDragIndicator(.visible)
        }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
            .environmentObject(FeedsViewModel())
    }
}
