//
//  HLSStreamRepositoryImpl.swift
//  StreamingData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation
import StreamingDomain

public final class HLSStreamRepositoryImpl: FetchHLSStreamUseCase {
    public init() { }

    public func execute() -> [HLSStream] {
        return [
            .init(
                id: "apple-basic-gear1",
                title: "Apple Basic Stream",
                description: "Single bitrate stream (gear1)",
                url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear1/prog_index.m3u8")!
            ),
            .init(
                id: "apple-basic-variants",
                title: "Apple Basic Stream",
                description: "Master Playlist with multiple variants",
                url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
            ),
            .init(
                id: "apple-advanced-variants",
                title: "Apple Advanced Stream",
                description: "TS stream with multiple variants",
                url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")!
            ),
            .init(
                id: "tears-of-steel",
                title: "Tears of Steel",
                description: "CMAF / fMP4",
                url: URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")!
            )
        ]
    }
}
