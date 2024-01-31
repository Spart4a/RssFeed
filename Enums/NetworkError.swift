//
//  NetworkError.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation

enum NetworkError: Error {
    case noData
    case databaseError
    case errorMessage(String)
}

