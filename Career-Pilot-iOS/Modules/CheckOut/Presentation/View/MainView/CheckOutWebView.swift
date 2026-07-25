//
//  CheckOutWebView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 23/07/2026.
//

import Foundation
import SwiftUI
import WebKit

struct PaymentWebView: UIViewRepresentable {
    let url: URL
    let onRedirect: (URL) -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onRedirect: onRedirect)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let onRedirect: (URL) -> Void
        init(onRedirect: @escaping (URL) -> Void) {
            self.onRedirect = onRedirect
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url,
               url.absoluteString.contains("payment-callback") {
                onRedirect(url)
                decisionHandler(.cancel)   
                return
            }
            decisionHandler(.allow)
        }
    }
}
