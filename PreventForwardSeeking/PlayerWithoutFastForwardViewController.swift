import UIKit
import AVKit

final class PlayerWithoutFastForwardViewController: AVPlayerViewController {
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPlayer()
    }

    private let videoURL = "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"

    private func startPlayer() {
        guard let url = URL(string: videoURL) else {
            print("'URL' cannot be formed with the string: \(videoURL)")
            return
        }

        let asset = AVAsset(url: url)
        let specialItemWithFFDisabled = PlayerItemWithFFDisabled(asset: asset)
        
        player = AVPlayer(playerItem: specialItemWithFFDisabled)
        delegate = self
        player?.play()
    }
}

extension PlayerWithoutFastForwardViewController: AVPlayerViewControllerDelegate {
    
    func playerViewController(_ playerViewController: AVPlayerViewController, timeToSeekAfterUserNavigatedFrom oldTime: CMTime, to targetTime: CMTime) -> CMTime {
        guard let currentItem = playerViewController.player?.currentItem else { return targetTime }
        
        let isForwarding = targetTime.seconds > oldTime.seconds
        if isForwarding {
            // Show Toast message here
            return currentItem.currentTime()
        }

        return targetTime
    }
}

class PlayerItemWithFFDisabled: AVPlayerItem {
    override var canPlayFastForward: Bool {
        false
    }

    override var canPlaySlowForward: Bool {
        false
    }
}
