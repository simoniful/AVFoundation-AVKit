//
//  AVMoviePlayer.swift
//  QuickPlay
//
//  Created by Sang hun Lee on 2022/09/29.
//

import Foundation
import SwiftUI
import AVKit

struct AVMoviePlayer: UIViewControllerRepresentable {
    typealias UIViewControllerType = AVPlayerViewController
    
    var player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let avViewController = AVPlayerViewController()
        avViewController.player = player
        avViewController.delegate = context.coordinator
        avViewController.showsPlaybackControls = true
        avViewController.requiresLinearPlayback = true
        // avViewController.allowsPictureInPicturePlayback = false
        return avViewController
    }
    
    class AVPlayerCoordinator: NSObject, AVPlayerViewControllerDelegate {
        func playerViewController(
            _ playerViewController: AVPlayerViewController,
            willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator
        ) { }
        
        func playerViewController(
            _ playerViewController: AVPlayerViewController,
            willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator
        ) {
            coordinator.animate(alongsideTransition: { (context) in
                // Add coordinated animations
            }) { (context) in
                // 여기서 전환이 성공햇는지, 취소됐는지 알 수 있습니다.
                if context.isCancelled {
                    print("전환 실패")
                } else {
                    print("전환 성공")
                    // Take strong reference to playerViewController if needed
                }
            }
        }
    }
    
   

    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> AVPlayerCoordinator {
        AVPlayerCoordinator()
    }
    
    
}


import AVKit
// 1a) Create an AVPlayer
let player = AVPlayer(
    url: URL(
        string: "https://my.example/video.m3u8"
    )!
)

// 1b) Add external metadata if needed
player.currentItem?.externalMetadata = // Array of [AVMetadataItem]

// 2) Create an AVPlayerViewController
let playerViewController = AVPlayerViewController()
playerViewController.player = player

// 3) Show it
present(playerViewController, animated: true)
