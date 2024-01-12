//
//  PlayerManager.swift
//  Player
//
//  Created by Smile on 2024/1/12.
//

import Foundation
import MediaPlayer

class PlayerManager {
    
    private weak var videoView: VideoView?
    
    // 操作
    enum ControlType {
        // 快进
        case fastForward
        
        // 快退
        case fastRewind
        
        // 调亮屏幕
        case lightingUp
        
        // 调暗屏幕
        case lightingDown
        
        // 音量调高
        case volumeUp
        
        // 音量调低
        case volumeDown
        
        var remindImage: UIImage? {
            switch self {
            case .fastForward:
                return UIImage(named: FAST_FORWARD_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil)
            case .fastRewind:
                return UIImage(named: FAST_REWIND_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil)
            case .lightingUp, .lightingDown:
                return UIImage(named: LIGHT_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil)
            default:
                return nil
            }
        }
    }
    

    convenience init(_ view: VideoView) {
        self.init()
        
        videoView = view
    }
}

// 播放器配置管理
class PlayerConfigManager: NSObject {
    
    // player view
    private var playerView: PlayerView?
    
    // 是否修改播放结束页面
    private var needChangeEndView: Bool = false
    
    // 播放配置
    var playerConfig: PlayerConfig? {
        willSet {
            print("player config will set")
            if let newConfig = newValue {
               
                if let oldConfig = playerConfig {
                    if let videoEndView = newConfig.videoEndView, (oldConfig.audioUrl == newConfig.audioUrl && oldConfig.videoUrl == newConfig.videoUrl) {
                        
                        //
                    }
                }
            }
        }
        
        didSet {
            print("player config did set")
            if self.needChangeEndView {
                self.needChangeEndView = false
                return
            }
            
            if let config = playerConfig {
                // 判断是不是 video, todo
                
                playerView?.playVideo(config)
            }
           
        }
    }
    
    // 播放状态
    var playerStatus: PlayerStatus? {
        didSet {
            if let status = playerStatus {
                // 按钮设置 TODO
                
                print("set status: \(status)")
                switch status {
                    case .playing:
                        guard self.playerView?.videoPlayer?.currentItem != nil else {
                            return
                        }
       
                        self.playerView?.videoPlayer?.play()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    convenience init(_ view: PlayerView) {
        self.init()
        self.playerView = view
    }
}

// 播放器状态
enum PlayerStatus {
    // 准备播放
    case prepare
    
    // 正在播放
    case playing
    
    // 暂停
    case pause
    
    // 停止播放
    case stop
    
    var controlPlayImage: UIImage? {
        switch self {
        case .playing:
            return UIImage(named: PLAYER_CONTROL_PLAY_BUTTON_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil)
        case .pause:
            return UIImage(named: PLAYER_CONTROL_PLAYING_BUTTON_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil)
        default:
            return nil
        }
    }
}
