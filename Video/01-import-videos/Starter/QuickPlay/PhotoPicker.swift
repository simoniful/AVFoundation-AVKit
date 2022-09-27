//
//  PHPPickerViewController.swift
//  QuickPlay
//
//  Created by Sang hun Lee on 2022/09/26.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    
    @Binding var isPresented: Bool
    @Binding var videos: [URL]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> PickerCoordinator {
        PickerCoordinator(photoPicker: self)
    }
    
    class PickerCoordinator: PHPickerViewControllerDelegate {
        
        let photoPicker: PhotoPicker
        let urls = [URL]()
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
            photoPicker.videos.removeAll()
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for result in results {
                let itemProvider = result.itemProvider
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                      let uType = UTType(typeIdentifier) else {
                    return
                }
                if uType.conforms(to: .movie) {
                    itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            guard let videoURL = url else { return }
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                            guard let targetURL = documentsDirectory?.appendingPathComponent(videoURL.lastPathComponent) else {
                                return
                            }
                            do {
                                if FileManager.default.fileExists(atPath: targetURL.path) {
                                    try FileManager.default.removeItem(at: targetURL)
                                }
                                try FileManager.default.copyItem(at: videoURL, to: targetURL)
                                DispatchQueue.main.async {
                                    self.photoPicker.videos.append(targetURL)
                                }
                            } catch {
                                // handle error
                            }
                        }
                    }
                }
            }
            photoPicker.isPresented = false
        }
    }
}
