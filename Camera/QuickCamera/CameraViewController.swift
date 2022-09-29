//
//  CameraViewController.swift
//  QuickCamera
//
//  Created by Sang hun Lee on 2022/09/29.
//

import UIKit
import AVFoundation
import PhotosUI

class CameraViewController: UIViewController {

    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    // let imageOutput = AVCapturePhotoOutput()
    let movieOutput = AVCaptureMovieFileOutput()
    
    var tempURL: URL? {
        let directory = NSTemporaryDirectory() as NSString
        if directory != "" {
            let path = directory.appendingPathComponent("video.mov")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        setupPreview()
        startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }
    
    func setupSession() {
        captureSession.beginConfiguration()
        // In case, Taking Picture: mic is not needed
        guard let camera = AVCaptureDevice.default(for: .video),
              let mic = AVCaptureDevice.default(for: .audio)
        else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: camera)
            let audioInput = try AVCaptureDeviceInput(device: mic)
            for input in [videoInput, audioInput] {
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            }
//            if captureSession.canAddOutput(imageOutput) {
//                captureSession.addOutput(imageOutput)
//            }
            activeInput = videoInput
        } catch {
            print("Error setting device input: \(error)")
            return
        }
        captureSession.addOutput(movieOutput)
        captureSession.commitConfiguration()
    }
    
    func setupPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.captureSession.stopRunning()
            }
        }
    }
    
    func camera(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        let devices = discovery.devices.filter {
            $0.position == position
        }
        return devices.first
    }
    
    public func switchCamera() {
        let position: AVCaptureDevice.Position = (activeInput.device.position == .back) ? .front : .back
        
        guard let device = camera(for: position) else {
            return
        }
        captureSession.beginConfiguration()
        captureSession.removeInput(activeInput)
        
        do {
            activeInput = try AVCaptureDeviceInput(device: device)
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        captureSession.addInput(activeInput)
        captureSession.commitConfiguration()
    }
    
//    public func capturePhoto(flashMode: AVCaptureDevice.FlashMode) {
//        let settings = AVCapturePhotoSettings()
//        settings.isAutoRedEyeReductionEnabled = true
//
//        let device = activeInput.device
//        if device.hasFlash {
//            if imageOutput.supportedFlashModes.contains(flashMode) {
//                settings.flashMode = flashMode
//            }
//        }
//        imageOutput.capturePhoto(with: settings, delegate: self)
//    }
    
    public func captureMovie() {
        guard let connection = movieOutput.connection(with: .video) else {
            return
        }
        if connection.isVideoStabilizationSupported {
            connection.preferredVideoStabilizationMode = .auto
        }
        
        let device = activeInput.device
        if device.isSmoothAutoFocusEnabled {
            do {
                try device.lockForConfiguration()
                device.isSmoothAutoFocusEnabled = true
                device.unlockForConfiguration()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        guard let outURL = tempURL else { return }
        movieOutput.startRecording(to: outURL, recordingDelegate: self)
    }
    
    public func stopRecording() {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
        }
    }
}

//extension CameraViewController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//            return
//        }
//
//        guard let photoData = photo.fileDataRepresentation() else {
//            return
//        }
//
//        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
//            if status == .authorized {
//                PHPhotoLibrary.shared().performChanges {
//                    let request = PHAssetCreationRequest.forAsset()
//                    request.addResource(
//                        with: .photo,
//                        data: photoData,
//                        options: nil
//                    )
//                } completionHandler: { success, error in
//
//                }
//            }
//        }
//    }
//}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges {
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                    } completionHandler: { success, error in
                        
                    }
                }
            }
        }
    }
}
