//
//  HLSThumbnailGenerator.swift
//  StreamingPresentation
//
//  Created by 백래훈 on 11/13/25.
//

import AVFoundation
import UIKit

final class HLSThumbnailGenerator {
    func generateThumbnail(from url: URL, at seconds: Double = 12.0) async -> UIImage? {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 800, height: 450)

        func generate(at timeSeconds: Double) async -> UIImage? {
            let time = CMTime(seconds: timeSeconds, preferredTimescale: 600)
            return await withCheckedContinuation { continuation in
                imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, result, _ in
                    switch result {
                    case .succeeded:
                        if let cgImage {
                            continuation.resume(returning: UIImage(cgImage: cgImage))
                        } else {
                            continuation.resume(returning: nil)
                        }
                    default:
                        continuation.resume(returning: nil)
                    }
                }
            }
        }

        // 1차: 기본 seconds (12초 등)
        if let thumbnail = await generate(at: seconds) {
            return thumbnail
        }
        // 2차: fallback 10초 지점
        return await generate(at: 10.0)
    }
}
