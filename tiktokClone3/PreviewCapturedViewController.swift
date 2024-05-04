//
//  PreviewCapturedViewController.swift
//  tiktokClone3
//
//  Created by Mahmut Başcı on 29.04.2024.
//

import UIKit
import AVKit

class PreviewCapturedViewController: UIViewController {
    
    var  currentPlayingVideoClip: VideoClips
    let recordedClips: [VideoClips]
    var viewWillDenitRestartVideoSession: (() -> Void)?
    var player: AVPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    var urlsForVids: [URL] = [] {
        didSet{
            print("outputUrlunwrapped:", urlsForVids)
        }
    }
    var hideStatusBar: Bool = true {
        didSet{
            UIView.animate(withDuration: 0.3){ [weak self] in
                self?.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    @IBOutlet weak var thumbnailImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        handleStartPlayingFirstClip()
        hideStatusBar = true
        recordedClips.forEach { clip in
            urlsForVids.append(clip.videoUrl)
        }
        print("\(recordedClips.count)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        player.play()
        hideStatusBar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        player.pause()
        
    }
    
    deinit {
        print("PreviewCaptureVideVC was deineted")
        (viewWillDenitRestartVideoSession)?()
    }

    
    init?(coder: NSCoder, recordedClips: [VideoClips]) {
        self.currentPlayingVideoClip = recordedClips.first!
        self.recordedClips = recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func handleStartPlayingFirstClip(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            guard let firstClip = self.recordedClips.first else {return}
            self.currentPlayingVideoClip = firstClip
            self.setupPlayerView(with: firstClip)
        }
    }
    
    func setupPlayerView(with videoClip: VideoClips) {
        let player = AVPlayer(url: videoClip.videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        self.player = player
        self.playerLayer = playerLayer
        playerLayer.frame = thumbnailImageView.frame
        self.player = player
        self.playerLayer = playerLayer
        thumbnailImageView.layer.insertSublayer(playerLayer, at: 3)
        player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemDidPlayToEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        handleMirrorPlayer(cameraPosition: videoClip.cameraPosition)

    }
    func removePeriodicTimeObserver(){
        player.replaceCurrentItem(with: nil)
        playerLayer.removeFromSuperlayer()
    }
    @objc func avPlayerItemDidPlayToEnd(notification: Notification) {
        if let currentIndex = recordedClips.firstIndex(of: currentPlayingVideoClip) {
            let nextIndex = currentIndex + 1
            if nextIndex > recordedClips.count - 1{
                removePeriodicTimeObserver()
                guard let firstClip = recordedClips.first else {return}
                setupPlayerView(with: firstClip)
                currentPlayingVideoClip = firstClip
            } else {
                for (index, clip) in recordedClips.enumerated() {
                    if index == nextIndex {
                        removePeriodicTimeObserver()
                        setupPlayerView(with: clip)
                        currentPlayingVideoClip = clip
                    }
                }
            }
        }
    }
    
    func handleMirrorPlayer(cameraPosition: AVCaptureDevice.Position){
        if cameraPosition == .front {
            thumbnailImageView.transform = CGAffineTransform(scaleX: -1, y: -1)
            
        }else {
            thumbnailImageView.transform = .identity
        }
    }


    
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
    }
    
}
