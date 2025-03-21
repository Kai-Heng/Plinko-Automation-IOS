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
    @State private var brainlessMode: Bool = false
    @State private var keyboardHeight: CGFloat = 0 // Track keyboard height
    
    @State private var showSplash = true


    var body: some View {
        ZStack{
            VStack(spacing: 10) {
                webView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 1) {
                    HStack(spacing: 6) {
                        Button("Start") {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            webView.startJS()
                        }
                        .buttonStyle(ActionButtonStyle(color: Color(UIColor(hue: 0.6361, saturation: 0.83, brightness: 1, alpha: 1.0))))
                        
                        Button("Pause") {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            webView.pauseJS()
                        }
                        .buttonStyle(ActionButtonStyle(color: Color(UIColor(hue: 0.1333, saturation: 0.83, brightness: 1, alpha: 1.0))))
                        
                        Button("Resume") {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            webView.resumeJS()
                        }
                        .buttonStyle(ActionButtonStyle(color: Color(UIColor(hue: 0.3694, saturation: 0.83, brightness: 0.65, alpha: 1.0))))
                        Button("Stop") {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            webView.stopJS()
                        }
                        .buttonStyle(ActionButtonStyle(color: Color(UIColor(hue: 0, saturation: 0.83, brightness: 1, alpha: 1.0))))
                    }
                    .padding()
                    
                    HStack(spacing: 10) {
                        Toggle("Brainless", isOn: $brainlessMode)
                            .onChange(of: brainlessMode) {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                webView.toggleBrainlessMode(brainlessMode)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            .frame(width: 130)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica-Bold", size: 13))
                        
                        TextField("Target Balance", text: $userTargetBalance)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                            .font(.custom("Helvetica-Bold", size: 13))
                            .padding(5)
                            .onTapGesture {
                                withAnimation {}
                            }
                        
                        Button("Set") {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            
                            if let val = Double(userTargetBalance) {
                                webView.setTargetBalance(val)
                            }
                            hideKeyboard()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.blue)
                        .font(.custom("Helvetica-Bold", size: 18))
                    }
                    .padding()
                }
                .cornerRadius(10)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor(hue: 0.5139, saturation: 0.49, brightness: 0.18, alpha: 1.0)))
            .edgesIgnoringSafeArea(.all)
            .offset(y: -keyboardHeight) // Move everything up
            .animation(.easeInOut(duration: 0.3), value: keyboardHeight) // Fix deprecated animation
            .onAppear {
                observeKeyboard()
            } // Start listening for keyboard changes
            
            // Splash Screen Overlay
            if showSplash {
                SplashView()
                    .transition(.opacity)  // Fade effect
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }


    /// Detects keyboard events and updates `keyboardHeight`
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                // Clamp so it won't push UI too high
                let offset = keyboardFrame.height
                // Limit offset to 0.2 so there's no big gap
                keyboardHeight = max(min(offset, 0.2), 0)
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            keyboardHeight = 0
        }
    }
}

/// Hide Keyboard on Tap
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/// Button Style
struct ActionButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .font(.custom("Helvetica-Bold", size: 15))
    }
}

#Preview {
    ContentView()
}
