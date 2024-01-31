//
//  RssFeedView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI
import AlertToast

struct RSSFeedListView: View {
    @EnvironmentObject private var rssFeedViewModel: RssFeedsViewModel
    @EnvironmentObject private var appSettings: AppEnvironment
    
    @State private var isAddViewPresented: Bool = false
    @State private var isOptionsViewPresented: Bool = false
    
    private let toastDuration = 3.0
    private let errorToastDuration = 4.0
    
 
    var body: some View {
        NavigationView {
            VStack {
                List(rssFeedViewModel.activeFeeds, id: \.self) { feed in
                    FeedCellView(feed: feed)
                }
                .environmentObject(rssFeedViewModel)
                .listStyle(.plain)
            }
            .navigationTitle(rssFeedViewModel.pageTitle)
            .navigationBarTitleDisplayMode(.inline)
            .background(
                EmptyStateView(
                    isEmpty: rssFeedViewModel.activeFeeds.isEmpty,
                    message: rssFeedViewModel.emptyStateMessage)
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isOptionsViewPresented.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .foregroundStyle(.blue)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                AddButtonView(isPressed: $isAddViewPresented)
                    .padding()
            }
            .toast(isPresenting: $rssFeedViewModel.notificationManager.isShowingSuccessToast, duration: toastDuration) {
                AlertToast(displayMode: .banner(.pop), type: .complete(.green), title: rssFeedViewModel.notificationManager.successToastMessage)
            }
            .toast(isPresenting: $rssFeedViewModel.notificationManager.isShowingLoadingToast, duration: toastDuration) {
                AlertToast(type: .loading)
            }
            .toast(isPresenting: $rssFeedViewModel.notificationManager.isShowingErrorToast, duration: errorToastDuration) {
                AlertToast(displayMode: .banner(.pop), type: .error(.red), title: rssFeedViewModel.notificationManager.errorToastMessage, style: .style(titleColor: .red,titleFont: .body, subTitleFont: .body))
            }
            .onAppear {
                self.isOptionsViewPresented = false
                self.isAddViewPresented = false
            }
        }
        .sheet(isPresented: $isAddViewPresented, content: {
            AddFeedView()
                .environmentObject(rssFeedViewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(150)])
        })
        .sheet(isPresented: $isOptionsViewPresented, content: {
            SettingsView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(150)])
                .environmentObject(appSettings)
        })
        .sheet(item: $rssFeedViewModel.currentFeed) { feed in
                    FeedItemsListView(feed: feed.rssFeed)
                        .environmentObject(rssFeedViewModel)
                        .presentationDragIndicator(.visible)
                }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
            .environmentObject(RssFeedsViewModel())
    }
}

