//
//  StringExtension.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation

extension String {
    var removingHTMLTags: String {
        return replacingOccurrences(of:"<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var removingNewLines: String {
        return replacingOccurrences(of: "\n", with: "")
    }
}
