//
//  CameraView.swift
//  QuickCamera
//
//  Created by Sang hun Lee on 2022/09/29.
//

import Foundation
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController
    private let cameraViewController: CameraViewController
    
    init() {
        cameraViewController = CameraViewController()
    }
    
    func makeUIViewController(context: Context) -> CameraViewController {
        cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
    }
    
    public func switchCamera() {
        cameraViewController.switchCamera()
    }
}

