//
//  PreviewCapturedViewController.swift
//  tiktokClone3
//
//  Created by Mahmut Başcı on 29.04.2024.
//

import UIKit

class PreviewCapturedViewController: UIViewController {
    
    var  currentPlayingVideoClip: VideoClips
    let recordedClips: [VideoClips]
    var viewWillDenitRestartVideoSession: (() -> Void)?
    
    deinit {
        print("PreviewCaptureVideVC was deineted")
        (viewWillDenitRestartVideoSession)?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("\(recordedClips.count)")

        
    }
    init?(coder: NSCoder, recordedClips: [VideoClips]) {
        self.currentPlayingVideoClip = recordedClips.first!
        self.recordedClips = recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
