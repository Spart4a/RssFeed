//
//  AddFeedView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI
import AlertToast

struct AddFeedView: View {
    @EnvironmentObject var feedViewModel: FeedsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var urlString: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Paste or type RSS feed URL here", text: $urlString)
                    .keyboardType(.URL)
                    .textFieldStyle(TextFieldColor())
            }
            .padding()
            .navigationTitle("Add RSS Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .toast(isPresenting: $feedViewModel.notificationManager.isShowingErrorToast, duration: 4) {
                AlertToast(
                    displayMode: .banner(.pop),
                    type: .error(.red),
                    title: feedViewModel.notificationManager.errorToastMessage
                )
            }
        }
    }

    private var addButton: some View {
        Button(action: addFeedAction) {
            Text("Add Feed")
                .bold()
                .foregroundStyle(.blue)
        }
        .disabled(feedViewModel.notificationManager.isShowingLoadingToast)
    }

    private func addFeedAction() {
        feedViewModel.getFeed(from: urlString) {
            dismiss()
        }
    }
}


