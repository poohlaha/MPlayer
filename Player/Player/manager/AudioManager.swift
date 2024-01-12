//
//  AudioManager.swift
//  Player
//
//  Created by Smile on 2024/1/12.
//

import Foundation
import UIKit

class AudioManager: NSObject {
    
    private weak var videoView: VideoView?
    
    convenience init(_ view: VideoView) {
        self.init()
        
        videoView = view
    }
}
