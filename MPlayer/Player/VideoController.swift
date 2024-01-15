// 视频控制器

import UIKit

class VideoViewController: UIViewController {
    
    // 是否响应旋转屏幕
    private var isRotateEnable = true
    
    // 等待缓存列表
    private var waitCacheUrlList: [URL]?
    
    // 播放列表
    private var playerArray: [PlayerConfig]?
    
    // 播放器
    private var videoView: PlayerView?
    
    // 背景
    private var backgroundView: BackgroundView?
    
    // 缓存列表
    private var cacheView: CacheView?
    
    
    override func viewDidLoad() {
        
    }
}
