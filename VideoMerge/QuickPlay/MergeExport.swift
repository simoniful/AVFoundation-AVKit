//
//  MergeExport.swift
//  QuickPlay
//
//  Created by Sang hun Lee on 2022/09/29.
//

import Foundation
import AVKit

class MergeExport: ObservableObject {
    @Published var exportURL: URL?
    
    var previewURL : URL?
    var videoURLs = [URL]()
    let HDVideoSize = CGSize(width: 1920.0, height: 1080.0)
    
    var uniqueURL: URL {
        var directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let date = dateFormatter.string(from: Date())
        directory.appendPathComponent("merge-\(date).mov")
        return directory
    }
    
    func previewMerge() -> AVPlayerItem {
        let videoAssets = videoURLs.map {
            AVAsset(url: $0)
        }
        let composition = AVMutableComposition()
        if let videoTrack = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid)
        ), let audioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid)
        ) {
            var startTime = CMTime.zero
            for asset in videoAssets {
                do {
                    try videoTrack.insertTimeRange(
                        CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                        of: asset.tracks(withMediaType: .video)[0],
                        at: startTime
                    )
                    try audioTrack.insertTimeRange(
                        CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                        of: asset.tracks(withMediaType: .audio)[0],
                        at: startTime
                    )
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
                startTime = CMTimeAdd(startTime, asset.duration)
            }
        }
        return AVPlayerItem(asset: composition)
    }
    
    func mergeAndExportVideo() {
        try? FileManager.default.removeItem(at: uniqueURL)
        
        let videoAssets = videoURLs.map {
            AVAsset(url: $0)
        }
        let composition = AVMutableComposition()
        let mainInstruction = AVMutableVideoCompositionInstruction()
        if let videoTrack = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid)
        ), let audioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid)
        ) {
            var startTime = CMTime.zero
            for asset in videoAssets {
                do {
                    try videoTrack.insertTimeRange(
                        CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                        of: asset.tracks(withMediaType: .video)[0],
                        at: startTime
                    )
                    try audioTrack.insertTimeRange(
                        CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                        of: asset.tracks(withMediaType: .audio)[0],
                        at: startTime
                    )
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
                
                let instruction = videoCompositionInstructionFor(
                    track: videoTrack,
                    using: asset
                )
                instruction.setOpacity(1.0, at: startTime)
                
                if asset != videoAssets.last {
                    instruction.setOpacity(
                        0.0,
                        at: CMTimeAdd(startTime, asset.duration)
                    )
                }
                
                mainInstruction.layerInstructions.append(instruction)
                startTime = CMTimeAdd(startTime, asset.duration)
            }
            
            let totalDuration = startTime
            mainInstruction.timeRange = CMTimeRangeMake(
                start: CMTime.zero,
                duration: totalDuration
            )
            
            let videoComposition = AVMutableVideoComposition()
            videoComposition.instructions = [mainInstruction]
            videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
            videoComposition.renderSize = HDVideoSize
            videoComposition.renderScale = 1.0
            
            guard let exporter = AVAssetExportSession(
                asset: composition,
                presetName: AVAssetExportPresetHighestQuality
            ) else { return }
            exporter.outputURL = uniqueURL
            exporter.outputFileType = .mov
            exporter.shouldOptimizeForNetworkUse = true
            exporter.videoComposition = videoComposition
            
            exporter.exportAsynchronously {
                DispatchQueue.main.async { [weak self] in
                    if let exportURL = exporter.outputURL {
                        self?.exportURL = exportURL
                    }
                }
            }
        }
    }
    
    func videoCompositionInstructionFor(track: AVCompositionTrack, using asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: .video)[0]
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFrom(transform: transform)
        var scaleToFitRatio = HDVideoSize.width / assetTrack.naturalSize.width
        if assetInfo.isPortrait {
            scaleToFitRatio = HDVideoSize.height / assetTrack.naturalSize.width
            let scaleFactor = CGAffineTransform(
                scaleX: scaleToFitRatio,
                y: scaleToFitRatio
            )
            let concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(
                CGAffineTransform(
                    translationX: (assetTrack.naturalSize.width * scaleToFitRatio) * 0.60,
                    y: 0
                )
            )
            instruction.setTransform(concat, at: CMTime.zero)
        } else {
            let scaleFactor = CGAffineTransform(
                scaleX: scaleToFitRatio,
                y: scaleToFitRatio
            )
            let concat = assetTrack.preferredTransform.concatenating(scaleFactor)
            instruction.setTransform(concat, at: CMTime.zero)
        }
        return instruction
    }
    
    func orientationFrom(transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            isPortrait = true
            assetOrientation = .right
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            isPortrait = true
            assetOrientation = .left
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
}
