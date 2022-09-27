//
//  Thumbnail.swift
//  QuickPlay
//
//  Created by Sang hun Lee on 2022/09/26.
//

import SwiftUI
import AVFoundation

struct Thumbnail: View {
    let thumbnailImage: UIImage?
    
    init(url: URL) {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            thumbnailImage = UIImage(cgImage: imageRef)
        } catch {
            thumbnailImage = nil
        }
    }
    
    var body: some View {
        if let thumbnail = thumbnailImage {
            Image(uiImage: thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.trailing)
        } else {
            EmptyView()
        }
    }
    
}

