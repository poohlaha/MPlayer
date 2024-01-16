// 播放器相关管理
// 包括状态、进度、状态等

import Foundation
import MediaPlayer

class PlayerManager: NSObject {
    
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
                return UIImage(named: PLAYER_CONTROL_PLAYING_BUTTON_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil)
            case .pause:
                return UIImage(named: PLAYER_CONTROL_PLAY_BUTTON_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil)
            default:
                return nil
            }
        }
    }
 
    private weak var panelView: PlayerPanelView?
    
    convenience init(_ panelView: PlayerPanelView) {
        self.init()
        self.panelView = panelView
    }
    
    private var playerConfig: PlayerConfig? {
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
            
            if let config = playerConfig {
                // 判断是不是 video, todo
                self.panelView?.playVideo(config)
            }
           
        }
    }
    
    // 播放状态
    private var playerStatus: PlayerStatus? {
        didSet {
            if let status = playerStatus {
                // 按钮设置
                if let controlPlayImage = status.controlPlayImage {
                    self.panelView?.getControlView().updatePlayImage(controlPlayImage)
                }
               
                switch status {
                    case .playing:
                        guard self.panelView?.videoView.getCurrentItem() != nil else {
                            return
                        }
       
                        self.panelView?.videoView.play()
                        break
                    
                case .pause:
                    
                    self.panelView?.videoView?.pause()
                    break
                    
                    default:
                        break
                }
            }
        }
    }
    
    // 设置播放器状态
    package func setPlayerStatus(_ status: PlayerStatus) {
        self.playerStatus = status
    }
    
    // 设置播放器属性
    package func setPlayerConfig(_ config: PlayerConfig) {
        self.playerConfig = config
    }
    
    // 获取播放器状态
    package func getPlayerStatus() -> PlayerStatus? {
        return self.playerStatus
    }
    
    // 获取播放器属性
    package func getPlayerConfig() -> PlayerConfig? {
        return self.playerConfig
    }
}
