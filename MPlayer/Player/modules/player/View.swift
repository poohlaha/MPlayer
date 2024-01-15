// 播放器 view, 只处理播放器相关

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    // 播放器
    private var videoPlayer: AVPlayer?
    
    // 播放器 layer
    private var videoPlayerLayer: AVPlayerLayer?
    
    // 媒体资源管理对象
    private var videoPlayerItem: AVPlayerItem? {
        didSet {
            if let playerItem = videoPlayerItem {
                playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            }
        }
    }
    
    // 当前播放 url
    private var currentUrl: String?
    
    // 是否网上资源
    package var isOnlineSource: Bool = true
    
    // 视频播放尺寸
    private var videoSize: CGSize?
    
    // 是否横屏
    private var isHorizontalScreen: Bool = false
    
    // 是否全屏
    private var isFullScreen: Bool = false
    
    // 是否正在播放
    private var playing: Bool = false
    
    // 是否有网络
    private var hasNetwork: Bool = false
    
    // 初始化
    init(_ frame: CGRect, _ hasNetwork: Bool) {
        super.init(frame: frame)
        
        self.hasNetwork = hasNetwork
        // 初始化一些属性
        initProps()
    }
    
    // 初始化一些属性
    private func initProps() {
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化播放器
    private func initPlayer(_ item: AVPlayerItem) {
        self.videoPlayer = AVPlayer(playerItem: item)
        self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
        self.videoPlayerLayer?.videoGravity = .resizeAspectFill
        self.videoPlayerLayer?.frame = getPlayerFrame()
        self.layer.addSublayer(self.videoPlayerLayer!)
    }
    
    // 通过配置初始化
    package func initWithConfig(_ config: PlayerConfig) {
        
    }

    // 播放视频
    package func play(_ url: String, _ config: PlayerConfig, completion: @escaping(AVPlayerItem) -> Void) {
        self.currentUrl = url
        self.isOnlineSource = isOnlineSource(url)
        
        // 获取播放地址
        var playUrl: URL
        if self.isOnlineSource {
            playUrl = URL(string: url)!
        } else {
            playUrl = URL(fileURLWithPath: url)
        }
        
        print("play video url: \(playUrl)")
        // 判断是否需要缓存, 需要判断网络状态
        if config.needCache && self.isOnlineSource  {
            // 先判断是不是有缓存文件
            
            // 如果要缓存, 先判断网络状态
            if !self.hasNetwork {
                print("无法缓存视频, 请检查网络状态 !")
                return
            }
            
            return
        }
        
        // 不缓存, 直接播放
        print("开始播放视频")
        let item: AVPlayerItem = AVPlayerItem(url: playUrl)
        let asset = AVURLAsset(url: playUrl)
        
        // 获取视频大小
        for track in asset.tracks {
            if track.mediaType == .video {
                self.videoSize = track.naturalSize
            }
        }
        
        completion(item)
    }
    
    // 播放视频
    package func playVideo(_ item: AVPlayerItem, _ config: PlayerConfig) {
        self.videoPlayerItem = item
        self.videoPlayer?.pause()
        
        if videoPlayer == nil {
            // 初始化播放器
            initPlayer(item)
        } else {
            // 替换播放资源
            videoPlayer?.replaceCurrentItem(with: item)
        }
    }
    
    // 获取播放器画面尺寸
    private func getPlayerFrame() -> CGRect {
        if let size = self.videoSize {
            // 判断是否横屏
            self.isHorizontalScreen = judgeIsHorizontalScreen()
            let isVerticalScreen = !self.isHorizontalScreen
            
            let isVertical = isFullScreen ? size.height / size.width > BasicUtils.SCREEN_WIDTH / BasicUtils.SCREEN_HEIGHT : isVerticalScreen
            
            if isVertical {
                // 竖屏
                if isFullScreen {
                    let playerWidth = BasicUtils.SCREEN_HEIGHT / size.height * size.width
                    return CGRectMake((BasicUtils.SCREEN_WIDTH - playerWidth) / 2, 0, playerWidth, BasicUtils.SCREEN_HEIGHT)
                }
                
                let playerWidth = BasicUtils.PLAYER_WIDTH / size.height * size.width
                return CGRectMake((BasicUtils.SCREEN_WIDTH - playerWidth) / 2, 0, playerWidth, BasicUtils.PLAYER_WIDTH)
            }
            
            // 横屏
            if isFullScreen {
                let playerHeight = BasicUtils.SCREEN_WIDTH / size.height * size.width
                return CGRectMake(0, (BasicUtils.SCREEN_HEIGHT - playerHeight) / 2, BasicUtils.SCREEN_WIDTH, playerHeight)
            }
            
            let playerHeight = BasicUtils.SCREEN_WIDTH / size.width * size.height
            return CGRectMake(0, (BasicUtils.PLAYER_WIDTH - playerHeight) / 2, BasicUtils.SCREEN_WIDTH, playerHeight)
        }
        
        return CGRectMake(0, 0, BasicUtils.SCREEN_WIDTH, BasicUtils.PLAYER_WIDTH)
    }
    
    // 判断是否为横屏
    private func judgeIsHorizontalScreen() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    // 判断是否网上资源
    private func isOnlineSource(_ url: String) -> Bool {
        return url.starts(with: "http://") || url.starts(with: "https://")
    }
    
    deinit {
        if let playerItem = videoPlayerItem {
            playerItem.removeObserver(self, forKeyPath: "status", context: nil)
        }
    }
}

// MARK: 事件监听
extension PlayerView {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = self.videoPlayerItem else {
            return
        }
        
        if keyPath == "status" {
            if item.status == .readyToPlay {
                print("播放器就绪")
            }
            
            if item.status == .failed {
                print("Failed to load video: \(self.videoPlayerItem?.error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}


// MARK: 对外事件
extension PlayerView {
    
    // 播放事件
    package func play() {
        self.videoPlayer?.play()
    }
    
    // 播放事件
    package func pause() {
        self.videoPlayer?.pause()
    }
    
    // 获取当前 Item
    package func getCurrentItem() -> AVPlayerItem? {
        return videoPlayer?.currentItem
    }
    
    // 设置播放进度
    package func setSeek(_ time: CMTime) {
        self.videoPlayer?.seek(to: time)
    }
    
    // 获取 videoPlayer
    package func getVideoPlayer() -> AVPlayer? {
        self.videoPlayer
    }
 
    // 设置是否全屏
    package func setIsFullscreen(_ isFullscreen: Bool) {
        self.isFullScreen = isFullscreen
    }
    
    // 获取是否全屏
    package func getIsFullscreen() -> Bool {
        self.isFullScreen
    }
    
    // 判断是否横屏
    package func getIsHorizontalScreen() -> Bool {
        return self.isHorizontalScreen
    }
}
