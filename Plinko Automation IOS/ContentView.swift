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

    var body: some View {
        VStack(spacing: 0) {
            webView
                .edgesIgnoringSafeArea(.all) // Remove top white space
                .frame(maxHeight: .infinity) // Make it fullscreen

            HStack(spacing: 20) {
                Button(action: {
                    webView.injectJavaScript()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Text("Start")
                        .font(.headline)
                        .frame(width: 120, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }

                Button(action: {
                    print("🚫 Stopping Automation (Reload Page)")
                    webView.webView.reload()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Text("Stop")
                        .font(.headline)
                        .frame(width: 120, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
            }
            .padding(.vertical, 10)
            .background(Color(.systemGray6)) // Light background for buttons
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    ContentView()
}
