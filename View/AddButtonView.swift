//
//  PlusButtonView.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import SwiftUI

struct AddButtonView: View {
    @Binding var isPressed: Bool
    
    var body: some View {
        Button(action: {
            self.isPressed.toggle()
        }, label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .center)
                .padding(10)
        })
        .foregroundStyle(.blue)
    }
}
