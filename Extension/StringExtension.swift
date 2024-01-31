//
//  StringExtension.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation

extension String {
    var trimHTMLTag: String {
        return replacingOccurrences(of:"<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var trimWhiteAndSpace: String {
        return replacingOccurrences(of: "\n", with: "")
    }
}
