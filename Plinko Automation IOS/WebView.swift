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

// MARK: - WebView
struct WebView: ViewRepresentable {
    let url: URL
    
    /// We create a WKWebView with a custom configuration that adds our message handler.
    var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        
        // We'll just add a dummy script user content controller here;
        // the actual coordinator will attach itself below in `makeCoordinator()`.
        // This placeholder ensures we have a custom config to allow JS -> Swift.
        config.userContentController = WKUserContentController()
        
        return WKWebView(frame: .zero, configuration: config)
    }()

    // MARK: - Make Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - iOS and macOS bridging
    #if os(iOS)
    func makeUIView(context: Context) -> WKWebView {
        setupWebView(context: context)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // No-op
    }
    #elseif os(macOS)
    func makeNSView(context: Context) -> WKWebView {
        setupWebView(context: context)
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        // No-op
    }
    #endif
    
    // MARK: - Setup
    private func setupWebView(context: Context) {
        // 1) Attach our coordinator as navigationDelegate + script message handler
        webView.navigationDelegate = context.coordinator
        
        // 2) Add coordinator as the script handler for the name "jsLog"
        webView.configuration.userContentController.add(context.coordinator, name: "jsLog")
        
        #if os(iOS)
        webView.scrollView.isScrollEnabled = true
        #endif
        
        // 3) Load the page
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Called whenever the page finishes loading
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Now that the page is loaded, inject the JS
            parent.injectJavaScript()
        }
        
        // Receive messages from JS via window.webkit.messageHandlers.jsLog.postMessage(...)
        func userContentController(_ userContentController: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            if message.name == "jsLog", let messageBody = message.body as? String {
                print("💬 JS Log:", messageBody)
            }
        }
    }

    // MARK: - JavaScript Injection
    func injectJavaScript() {
        let jsCode = """
        (function() {
            let running = false;
            let paused = false;
            let brainlessMode = false;
            let consecutiveLosses = 0;
            let lossStreakThreshold = 7;
            let previousFib = 0.0;
            let currentFib = 0.001;
            let lastMultiplier = "";
            let targetBalance = 999999999;
            let lastBetID = "";
            
            let betNumber = 0;
            let counter = 0;

            const betInputSelector = "#main-content > div.parent.svelte-1ydxan2 > div > div > div > div > div.content.svelte-s7t0yi.stacked > div.game-sidebar.svelte-2ftx9j.stacked > label:nth-child(1) > div > div.input-content.svelte-1nbx5re > input";
            const playButtonSelector = "#main-content > div.parent.svelte-1ydxan2 > div > div > div > div > div.content.svelte-s7t0yi.stacked > div.game-sidebar.svelte-2ftx9j.stacked > button";
            const multiplierSelector = "#main-content > div.parent.svelte-1ydxan2 > div > div > div > div > div.content.svelte-s7t0yi.stacked > div.game-content.svelte-1ku0r3.stacked > div > div.last-bet-wrap.svelte-1hd0qmg > div > button";
            const balanceSelector = "#svelte > div.wrap.svelte-2gw7o8 > div.main-content.svelte-2gw7o8 > div.navigation.svelte-1nt2705.mobile > div > div > div > div.balance-toggle.svelte-1o8ossz > div > div > div > button > div > div > span.content.svelte-didcjq > span";
            const coinSelector = "#svelte > div.wrap.svelte-2gw7o8 > div.main-content.svelte-2gw7o8 > div.navigation.svelte-1nt2705.mobile > div > div > div > div.balance-toggle.svelte-1o8ossz > div > div > div > button";
            const lastBetSelector = "#main-content > div.parent.svelte-1ydxan2 > div > div > div > div";

            function logToSwift(message) {
                try {
                    window.webkit.messageHandlers.jsLog.postMessage(message);
                } catch (err) {
                    console.log("[JS ERROR] WebKit MessageHandler not available.", err);
                }
            }

            function getElement(sel) {
                return document.querySelector(sel);
            }

            function parseMultiplier(text) {
                let cleaned = text.replace("×","").replace("x","").trim();
                let val = parseFloat(cleaned);
                return isNaN(val) ? 0 : val;
            }

            function getBalance() {
                // Update this query if the site changes the CSS path
                const balanceElement = document.querySelector(balanceSelector);
                if (balanceElement) {
                    let balanceText = balanceElement.innerText.trim().replace(/,/g, '');
                    let balanceValue = parseFloat(balanceText);
                    return isNaN(balanceValue) ? null : balanceValue;
                }
                return null;
            }
        
            function betLogic(){
                let multiplierEl = getElement(multiplierSelector);
                
                if (multiplierEl) {
                    let multiVal = parseMultiplier(multiplierEl.innerText || "");
                    if (multiVal > 0 && multiVal < 1.0) {
                        consecutiveLosses++;
                    } else if (multiVal >= 1.0) {
                        // reset
                        consecutiveLosses = 0;
                        previousFib = 0.0;
                        currentFib = 0.001;
                    }
                    lastMultiplier = multiplierEl.innerText;
                }
        
                let balance = getBalance();

                let betAmount = 0.0001;
                if (consecutiveLosses >= lossStreakThreshold) {
                    betAmount = balance * (previousFib + currentFib);
                    let temp = currentFib;
                    currentFib = temp + previousFib;
                    previousFib = temp;
                }
                else{
                    betAmount = balance * 0.0001
                }
                
                let currencyEl = document.querySelector(coinSelector);
                let currency = currencyEl ? currencyEl.getAttribute('data-active-currency') : "gold";
        
                if (betAmount < 0.11 && currency === "gold") {
                    betAmount = 0.11;
                }
                else if (betAmount < 0.01 && currency === "sweeps"){
                    betAmount = 0.01;
                }

                
                if (!isNaN(balance) && betAmount > balance * 0.5) {
                    betAmount = balance / 2;
                }
        
                logToSwift("Balance:" + balance);

                let betInput = getElement(betInputSelector);
                let playButton = getElement(playButtonSelector);
                if (betInput && playButton) {
                    betInput.value = betAmount.toFixed(2);
                    let event = new Event('input', { bubbles: true });
                    betInput.dispatchEvent(event);

                    playButton.click();
                    counter++;

                    logToSwift(counter + ". [AutoBet] Placed bet = " + betAmount.toFixed(2) + " | consecutiveLosses=" + consecutiveLosses);
                }

                if (balance >= targetBalance) {
                    running = false;
                    logToSwift("🏆 Reached target balance, stopping...");
                }
            }
        
            function brainless_bet_logic(){
                let balance = getBalance();

                let betAmount = 0.0001;

                betAmount = balance * 0.0001;

                
                let currencyEl = document.querySelector(coinSelector);
                let currency = currencyEl ? currencyEl.getAttribute('data-active-currency') : "gold";
        
                if (betAmount < 0.11 && currency === "gold") {
                    betAmount = 0.11;
                }
                else if (betAmount < 0.01 && currency === "sweeps"){
                    betAmount = 0.01;
                }


                let betInput = getElement(betInputSelector);
                let playButton = getElement(playButtonSelector);
                if (betInput && playButton) {
                    betInput.value = betAmount.toFixed(2);
                    let event = new Event('input', { bubbles: true });
                    betInput.dispatchEvent(event);

                    playButton.click();
                    counter++;

                    logToSwift(counter + ". [AutoBet] Placed bet = " + betAmount.toFixed(2));
                }

                if (balance >= targetBalance) {
                    running = false;
                    logToSwift("🏆 Reached target balance, stopping...");
                }
            }

            window.setTargetBalance = function(newVal) {
                targetBalance = parseFloat(newVal);
                logToSwift("✅ Target Balance set to: " + targetBalance);
            };
        
            window.plinkoStart = function() {
                running = true;
                paused = false
                logToSwift("▶️ STARTED from Swift");
            };

            window.plinkoPause = function() {
                paused = true;
                logToSwift("⏸ PAUSED from Swift");
            };
            window.plinkoResume = function() {
                paused = false;
                logToSwift("▶️ RESUMED from Swift");
            };
            window.plinkoStop = function() {
                running = false;
                paused = false
                logToSwift("⛔️ STOPPED from Swift");
            };
            
            window.toggleBrainlessMode = function(state) {
                brainlessMode = state;
                logToSwift("Brainless Mode: " + brainlessMode);
            };



            function placeBet() {
                if (!running){
                    return;
                }
                if (paused) {
                    logToSwift("⏸ Automation paused, skipping bet");
                    return;
                }
                
                if(brainlessMode){
                    brainless_bet_logic();
                }
                else{
                    if (lastBetID === ""){
                        let firstBetIDEl = getElement(lastBetSelector);
                        lastBetID = firstBetIDEl.getAttribute('data-last-bet');
                        logToSwift(lastBetID);
                        
                        betLogic();
                        return;
                    }
                    
                    let lastBetIDEl = getElement(lastBetSelector);
                    let currentBetID = lastBetIDEl.getAttribute('data-last-bet');
            
                    if(currentBetID != lastBetID){
                        lastBetID = currentBetID;
                        betLogic();
                    }
                }

            }

            // Place a bet every 1 seconds
            setInterval(placeBet, 1000);

            logToSwift("Plinko JS automation injected. Ready to bet...");
        })();
        """
        
        webView.evaluateJavaScript(jsCode) { result, error in
            if let error = error {
                print("❌ JavaScript Injection Error:", error)
            } else {
                print("✅ JavaScript Successfully Injected")
            }
        }
    }

    // MARK: - Swift Side Controls
    func startJS(){
        let code = "window.plinkoStart();"
        webView.evaluateJavaScript(code) { result, error in
            print("StartJS call -> result=\(String(describing: result)) error=\(String(describing: error))")
        }
    }
    func pauseJS() {
        let code = "window.plinkoPause();"
        webView.evaluateJavaScript(code) { result, error in
            print("PauseJS call -> result=\(String(describing: result)) error=\(String(describing: error))")
        }
    }

    func resumeJS() {
        let code = "window.plinkoResume();"
        webView.evaluateJavaScript(code) { result, error in
            print("ResumeJS call -> result=\(String(describing: result)) error=\(String(describing: error))")
        }
    }

    func stopJS() {
        let code = "window.plinkoStop();"
        webView.evaluateJavaScript(code) { result, error in
            print("StopJS call -> result=\(String(describing: result)) error=\(String(describing: error))")
        }
    }

    func setTargetBalance(_ value: Double) {
        // Format to ensure e.g. "1000.00"
        let formattedValue = String(format: "%.2f", value)
        let code = "window.setTargetBalance(\(formattedValue));"
        webView.evaluateJavaScript(code) { result, error in
            if let err = error {
                print("❌ Error setting target balance in JS:", err)
            } else {
                print("✅ Successfully set target balance to \(formattedValue)")
            }
        }
    }
    
    func toggleBrainlessMode(_ state: Bool) {
        let code = "window.toggleBrainlessMode(\(state));"
        webView.evaluateJavaScript(code)
    }
}
