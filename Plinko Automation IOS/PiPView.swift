//
//  PiPView.swift
//  Plinko Automation IOS
//
//  Created by Kai Heng on 3/25/25.
//

import Foundation
import SwiftUI
import AVKit

struct PiPView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AVPlayerViewController {
            let controller = AVPlayerViewController()

            guard let path = Bundle.main.path(forResource: "dummy1", ofType:"mp4") else {
                print("❌ dummy.mp4 not found.")
                return controller
            }

            let player = AVPlayer(url: URL(fileURLWithPath: path))
            controller.player = player
            controller.allowsPictureInPicturePlayback = true
            controller.entersFullScreenWhenPlaybackBegins = false
            controller.exitsFullScreenWhenPlaybackEnds = false
            controller.showsPlaybackControls = false

            // Start playing and request PiP
            player.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if AVPictureInPictureController.isPictureInPictureSupported(),
                   let pipController = AVPictureInPictureController(playerLayer: controller.contentOverlayView?.layer.sublayers?.first as? AVPlayerLayer ?? AVPlayerLayer(player: player)) {
                    pipController.startPictureInPicture()
                }
            }

            return controller
        }

        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

