//
//  TextFieldColor.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation
import SwiftUI

struct TextFieldColor: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .padding(10)
    }
}
