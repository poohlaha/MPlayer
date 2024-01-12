// 播放配置

import Foundation
import UIKit

struct PlayerConfig {
    
    // 标题
    var title: String?
    
    // 视频 url
    var videoUrl: String?
    
    // 音频 url
    var audioUrl: String?
    
    // 是否支持缓存
    var needCache: Bool = false
    
    // 是否断点续播
    var playContinue: Bool = true
    
    // 视频封面图
    var playHoldImage: String?
    
    // 视频播放结束页面
    var videoEndView: UIView?
    
    // 音频播放结束页面
    var audioEndView: UIView?
    
    init(
        title: String = "",
        videoUrl: String? = nil,
        audioUrl: String? = nil,
        needCache: Bool = false,
        playContinue: Bool = true,
        playHoldImage: String? = nil,
        videoEndView: UIView? = nil,
        audioEndView: UIView? = nil
    ) {
        self.title = title
        self.videoUrl = videoUrl
        self.audioUrl = audioUrl
        self.needCache = needCache
        self.playContinue = playContinue
        self.playHoldImage = playHoldImage
        self.videoEndView = videoEndView
        self.audioEndView = audioEndView
    }
}
