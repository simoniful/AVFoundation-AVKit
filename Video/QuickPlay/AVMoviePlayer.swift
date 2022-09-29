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
        return avViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> AVPlayerCoordinator {
        AVPlayerCoordinator()
    }
    
    class AVPlayerCoordinator: NSObject, AVPlayerViewControllerDelegate {
        
    }
    
}
