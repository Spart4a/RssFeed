//
//  AlertToastManager.swift
//  RssFeed
//
//  Created by Ivan on 24.01.2024..
//

import Foundation

struct NotificationManager {
    var isShowingSuccessToast = false
    var successToastMessage = ""
    var isShowingErrorToast = false
    var errorToastMessage = ""
    var isShowingLoadingToast = false
    var loadingToastMessage = ""
}

extension NotificationManager {
    mutating func showSuccessToast(withMessage message: String) {
        isShowingLoadingToast = false
        successToastMessage = message
    }
    
    mutating func showSucces() {
        isShowingSuccessToast.toggle()
    }
    
    mutating func showErrorToast(withMessage message: String) {
        isShowingLoadingToast = false
        errorToastMessage = message
    }
    
    mutating func showError() {
        isShowingErrorToast.toggle()
    }
    
    mutating func showLoadingToast() {
        isShowingLoadingToast = true
    }
    
    mutating func hideLoadingToast() {
        isShowingLoadingToast = false
    }
}
