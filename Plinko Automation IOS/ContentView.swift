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
        VStack(spacing: -15) {
            // The actual game
            webView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // Make sure it’s scrollable / no extra safe area padding:
                .edgesIgnoringSafeArea(.all)

            // Controls
            HStack(spacing: 5) {
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
                    .frame(width: 200)
                    .padding(8)
//                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .foregroundColor(.white)
                Button("Set") {
                    if let val = Double(userTargetBalance) {
                        webView.setTargetBalance(val)
                    }
                }
                .foregroundColor(.blue)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black) // 🔥 Change to a dark background
        .edgesIgnoringSafeArea(.all) // Ensure it fills the entire screen
    }
}

#Preview {
    ContentView()
}
