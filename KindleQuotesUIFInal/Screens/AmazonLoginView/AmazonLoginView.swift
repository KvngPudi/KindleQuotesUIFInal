//
//  AmazonLoginView.swift
//  KindleQuotesUIFInal
//
//  Created by Pranit Duddupudi on 8/3/24.
//

import SwiftUI
import WebKit

struct AmazonLoginView: UIViewRepresentable {
    @Binding var isLoggedIn: Bool

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: AmazonLoginView

        init(parent: AmazonLoginView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Started navigating to url \(webView.url?.absoluteString ?? "")")
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            checkForLoginSuccess(webView: webView)
            print("Finished navigating to url \(webView.url?.absoluteString ?? "")")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed to navigate to url \(webView.url?.absoluteString ?? "") with error: \(error.localizedDescription)")
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Failed to start navigation to url \(webView.url?.absoluteString ?? "") with error: \(error.localizedDescription)")
        }

        func checkForLoginSuccess(webView: WKWebView) {
            let loginIndicatorID = "kp-notebook-library"
            let javascript = "document.getElementById('\(loginIndicatorID)') != null"

            webView.evaluateJavaScript(javascript) { (result, error) in
                if let loggedIn = result as? Bool, loggedIn {
                    print("User successfully logged in")
                    self.parent.isLoggedIn = true
                    self.delayCaptureCookies(webView: webView)
                } else {
                    print("User not logged in yet")
                }
            }
        }

        func delayCaptureCookies(webView: WKWebView) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.captureCookies(webView: webView)
            }
        }

        func captureCookies(webView: WKWebView) {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                self.sendCookiesToServer(cookies: cookies)
            }
        }

        func sendCookiesToServer(cookies: [HTTPCookie]) {
            let url = URL(string: "http://54.89.225.92/save_cookies")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let cookieDict = cookies.reduce(into: [String: String]()) { dict, cookie in
                dict[cookie.name] = cookie.value
            }
            print("Cookies to be sent: \(cookieDict)")

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: cookieDict, options: [])
                print("Serialized JSON data: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
                request.httpBody = jsonData

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error sending cookies: \(error.localizedDescription)")
                    } else {
                        if let httpResponse = response as? HTTPURLResponse {
                            print("HTTP response status: \(httpResponse.statusCode)")
                        }
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response data: \(responseString)")
                        }
                    }
                }

                task.resume()
            } catch {
                print("Error serializing cookies to JSON: \(error.localizedDescription)")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        print("WKWebView created and delegates set")
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if !isLoggedIn {
            if let url = URL(string: "https://read.amazon.com/notebook?ref_=kcr_notebook_lib&language=en-US") {
                let request = URLRequest(url: url)
                print("Loading URL: \(url)")
                uiView.load(request)
            } else {
                print("Invalid URL")
            }
        }
    }
}

#Preview {
    AmazonLoginView(isLoggedIn: .constant(false))
}
