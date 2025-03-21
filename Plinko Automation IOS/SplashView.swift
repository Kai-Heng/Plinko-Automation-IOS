//
//  SplashView.swift
//  Plinko Automation IOS
//
//  Created by Kai Heng on 3/21/25.
//

import SwiftUI


struct SplashView: View {
    var body: some View {
        ZStack {
            Color(UIColor(hue: 0.8611, saturation: 0.42, brightness: 0.68, alpha: 1.0)).ignoresSafeArea()
            VStack(spacing: 20) {
                // Replace "logo" with the actual name of your asset
                Image("Image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Text("Plinko Bot")
                    .font(.custom("Helvetica-Bold", size: 28))
                    .foregroundColor(Color(UIColor(hue: 0.875, saturation: 0.02, brightness: 0.93, alpha: 1.0)))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // ✅ Ensures center alignment
        }
        
    }
}
