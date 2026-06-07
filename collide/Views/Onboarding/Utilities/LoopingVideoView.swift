//
//  LoopingVideoView.swift
//  collide
//
//  Created by Priyank Sharma on 07/06/26.
//

import SwiftUI
import AVFoundation

struct LoopingVideoView: UIViewRepresentable {

    let videoName: String

    func makeUIView(context: Context) -> PlayerUIView {

        let view = PlayerUIView()

        guard let url = Bundle.main.url(
            forResource: videoName,
            withExtension: "mp4"
        ) else {
            return view
        }

        let item = AVPlayerItem(url: url)

        let player = AVQueuePlayer()
        let looper = AVPlayerLooper(
            player: player,
            templateItem: item
        )

        view.playerLayer.player = player

        context.coordinator.player = player
        context.coordinator.looper = looper

        player.isMuted = true
        player.play()

        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var player: AVQueuePlayer?
        var looper: AVPlayerLooper?
    }
}

final class PlayerUIView: UIView {

    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = .resizeAspectFill
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
