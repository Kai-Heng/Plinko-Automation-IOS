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
    @State private var brainlessMode: Bool = false // Toggle state

    var body: some View {
            VStack(spacing: 10) {
                webView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 1) {
                    HStack(spacing: 6) {
                        Button("Start") {
                            webView.startJS()
                        }
                        .buttonStyle(ActionButtonStyle(color: Color(UIColor(hue: 0.6361, saturation: 0.83, brightness: 1, alpha: 1.0))))

                        Button("Pause") {
                            webView.pauseJS()
                        }
                        .buttonStyle(ActionButtonStyle(color: Color(UIColor(hue: 0.1333, saturation: 0.83, brightness: 1, alpha: 1.0))))

                        Button("Resume") {
                            webView.resumeJS()
                        }
                        .buttonStyle(ActionButtonStyle(color: Color(UIColor(hue: 0.3694, saturation: 0.83, brightness: 0.65, alpha: 1.0))))

                        Button("Stop") {
                            webView.stopJS()
                        }
                        .buttonStyle(ActionButtonStyle(color: Color(UIColor(hue: 0, saturation: 0.83, brightness: 1, alpha: 1.0))))
                    }
                    .padding()

                    HStack(spacing: 10) {
                        Toggle("Brainless", isOn: $brainlessMode)
                            .onChange (of: brainlessMode){ webView.toggleBrainlessMode(brainlessMode) }
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            .frame(width: 130)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica-Bold", size: 13))

                        TextField("Target Balance", text: $userTargetBalance)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                            .font(.custom("Helvetica-Bold", size: 13))

                        Button("Set") {
                            if let val = Double(userTargetBalance) {
                                webView.setTargetBalance(val)
                            }
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
        
//        Text("Available Font Families:")
//                        .padding()
//
//                    List {
//                        ForEach(UIFont.familyNames, id: \.self) { familyName in
//                            Section(header: Text(familyName)) {
//                                ForEach(UIFont.fontNames(forFamilyName: familyName), id: \.self) { fontName in
//                                    Text(fontName)
//                                        .font(.system(size: 14))
//                                        .padding(.vertical, 4)
//                                }
//                            }
//                        }
//                    }
//                    .padding()
          }
    }

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
