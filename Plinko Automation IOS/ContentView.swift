//
//  ContentView.swift
//  Plinko Automation IOS
//
//  Created by Kai Heng on 2/21/25.
//

import SwiftUI
import WebKit

struct ContentView: View {
    let plinkoURL = URL(string: "https://stake.us/casino/games/plinko")!

    @State private var webView = WebView(url: URL(string: "https://stake.us/casino/games/plinko")!)
    
    @State private var userTargetBalance: String = ""

    var body: some View {
        VStack(spacing: 16) {
            // The actual game
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // Make sure it’s scrollable / no extra safe area padding:
                .edgesIgnoringSafeArea(.all)

            // Controls
            HStack(spacing: 5) {
//                Button("Inject JS") {
//                    webView.injectJavaScript()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
                
                Button("Start") {
                    webView.startJS()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Pause") {
                    webView.pauseJS()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Resume") {
                    webView.resumeJS()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Stop") {
                    webView.stopJS()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()

            // Example: set target balance
            HStack {
                TextField("Target Balance", text: $userTargetBalance)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 120)
                Button("Set") {
                    if let val = Double(userTargetBalance) {
                        webView.setTargetBalance(val)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
