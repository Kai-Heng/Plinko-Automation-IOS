//
//  CookieManager.swift
//  Plinko Automation IOS
//
//  Created by Kai Heng on 2/21/25.
//

import Foundation
import WebKit

// Save Cookies
func saveCookies() {
    WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
        let cookieArray = cookies.map { $0.properties ?? [:] }
        UserDefaults.standard.set(cookieArray, forKey: "savedCookies")
        print("✅ Cookies saved successfully!")
    }
}

// Load Cookies
func loadCookies(completion: @escaping () -> Void) {
    guard let cookieArray = UserDefaults.standard.array(forKey: "savedCookies") as? [[HTTPCookiePropertyKey: Any]] else {
        print("⚠️ No saved cookies found.")
        completion()
        return
    }

    let cookieStore = WKWebsiteDataStore.default().httpCookieStore

    let dispatchGroup = DispatchGroup()

    for cookieProperties in cookieArray {
        if let cookie = HTTPCookie(properties: cookieProperties) {
            dispatchGroup.enter()
            cookieStore.setCookie(cookie) {
                dispatchGroup.leave()
            }
        }
    }

    dispatchGroup.notify(queue: .main) {
        print("✅ Cookies loaded successfully!")
        completion()
    }
}
