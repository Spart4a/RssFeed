//
//  BackgroundView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

struct EmptyStateView: View {
    var isEmpty: Bool = false
    var message: String
    
    var body: some View {
            VStack (alignment: .center) {
                if isEmpty {
                    emptyStateImage
                    emptyStateMessage
                }
            }
            .foregroundColor(.gray)
        }
    
    private var emptyStateImage: some View {
            Image(systemName: "newspaper")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
        }

    private var emptyStateMessage: some View {
            Text(message)
                .font(.system(size: 22))
    }
}
