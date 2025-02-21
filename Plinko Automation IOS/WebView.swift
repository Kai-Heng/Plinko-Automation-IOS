//
//  WebView.swift
//  Plinko Automation IOS
//
//  Created by Kai Heng on 2/21/25.
//

import Foundation
import SwiftUI
import WebKit

#if os(iOS)
import UIKit
typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
import AppKit
typealias ViewRepresentable = NSViewRepresentable
#endif

struct WebView: ViewRepresentable {
    let url: URL
    var webView = WKWebView()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    #if os(iOS)
    func makeUIView(context: Context) -> WKWebView {
        setupWebView()
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    #elseif os(macOS)
    func makeNSView(context: Context) -> WKWebView {
        setupWebView()
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {}
    #endif

    private func setupWebView() {
        let request = URLRequest(url: url)
        webView.load(request)
        webView.scrollView.isScrollEnabled = true  // Enable scrolling
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
    }

    func injectJavaScript() {
        let jsCode = """
        (function() {
            let fib = [0.01, 0.01];
            let betIndex = 1;
            let betAmount = fib[betIndex];

            function placeBet() {
                let betInput = document.querySelector("input");
                let playButton = document.querySelector("button");

                if (betInput && playButton) {
                    betInput.value = betAmount.toFixed(2);
                    playButton.click();

                    betIndex++;
                    fib.push(fib[betIndex - 1] + fib[betIndex - 2]);
                    betAmount = fib[betIndex];

                    setTimeout(() => {
                        let multiplier = document.querySelector(".multiplier");
                        if (multiplier && parseFloat(multiplier.innerText) > 1.0) {
                            betIndex = 1;
                            fib = [0.01, 0.01];
                        }
                    }, 2000);
                }
            }

            setInterval(placeBet, 3000);
        })();
        """
        webView.evaluateJavaScript(jsCode)
    }
}
