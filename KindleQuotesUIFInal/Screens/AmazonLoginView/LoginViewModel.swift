//
//  LoginViewModel.swift
//  KindleQuotesUIFInal
//
//  Created by Pranit Duddupudi on 8/3/24.
//

import Foundation
import SwiftUI
import WebKit

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        checkLoginStatus()
    }

    func checkLoginStatus() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if cookie.name == "session-token" && !cookie.value.isEmpty {
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        }
    }
}

