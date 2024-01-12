// 播放器 view, 只处理播放器相关

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    // 播放器
    var videoPlayer: AVPlayer?
    
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
    private var isOnlineSource: Bool = true
    
    // 没有网络时的视图
    private var noNetworkView: NoNetworkView!
    
    // 浏量播放弹框
    private var flowView: UIView!
    
    // 网络
    private var networkManager = NetworkManager()
    
    // 视频播放尺寸
    private var videoSize: CGSize?
    
    // 网络状态码
    private var networkCode: Int = 0
    
    // 是否横屏
    private var isHorizontalScreen: Bool = false
    
    // 是否全屏
    private var isFullScreen: Bool = false
    
    // 配置管理
    private var configManager: PlayerConfigManager?
    
    // 是否正在播放
    private var playing: Bool = false
    
    init(_ frame: CGRect) {
        super.init(frame: frame)
        
        self.configManager = PlayerConfigManager(self)
        
        // 初始化一些属性
        initProps()
        
        // 获取网络状态码
        getNetworkCode()
        
        // 创建没有网络情况下的提示
        createNoNetworkView()
        
        // 创建浏量播放视图
        createFlowView()
    }
    
    // 初始化一些属性
    private func initProps() {
        UIApplication.shared.isIdleTimerDisabled = true // 开启屏幕常量
        // 定时器 TODO
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 获取网络状态码
    private func getNetworkCode() {
        networkManager.setup { code in
            print("get code: \(code)")
            self.networkCode = 1 // todo
        }
    }
    
    // 初始化播放器
    private func initPlayer(_ item: AVPlayerItem) {
        self.videoPlayer = AVPlayer(playerItem: item)
        self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
        self.videoPlayerLayer?.videoGravity = .resizeAspectFill
        self.videoPlayerLayer?.frame = getPlayerFrame()
        print("video player layer frame: \(self.videoPlayerLayer?.frame)")
        self.layer.addSublayer(self.videoPlayerLayer!)
    }
    
    // 通过配置初始化
    private func initWithConfig(_ config: PlayerConfig) {
        
    }
    
    // 播放视频
    func playVideo(_ config: PlayerConfig) {
        DispatchQueue.main.async {
            self.initWithConfig(config)
        }
        
        var url = ""
        if let videoUrl = config.videoUrl, !videoUrl.isEmpty {
            url = videoUrl
        } else if let audioUrl = config.audioUrl, !audioUrl.isEmpty {
            url = audioUrl
        }
        
        if url.isEmpty {
            print("initPlayer init failed !")
            return
        }
       
        play(url, config)
    }
    
    // 播放视频
    private func play(_ url: String, _ config: PlayerConfig) {
        self.currentUrl = url
        self.isOnlineSource = isOnlineSource(url)
        
        // 获取播放地址
        var playUrl: URL
        if self.isOnlineSource {
            playUrl = URL(string: url)!
        } else {
            playUrl = URL(fileURLWithPath: url)
        }
        
        // print("play video url: \(playUrl)")
        // 判断是否需要缓存, 需要判断网络状态
        if config.needCache && self.isOnlineSource  {
            // 先判断是不是有缓存文件
            
            // 如果要缓存, 先判断网络状态
            if networkCode == 0 {
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
        
        print("video size: \(videoSize)")
        DispatchQueue.main.async {
            self.playVideo(item, config)
        }
    }
    
    // 播放视频
    private func playVideo(_ item: AVPlayerItem, _ config: PlayerConfig) {
        self.videoPlayerItem = item
        self.videoPlayer?.pause()
        
        if videoPlayer == nil {
            // 初始化播放器
            initPlayer(item)
        } else {
            // 替换播放资源
            videoPlayer?.replaceCurrentItem(with: item)
        }
        
        // 查看没有网络 view
        noNetworkView.isHidden = self.networkCode != 0
        
        // 查看是否有缓存
        // TODO
        
        // 如果是本地资源, 直接播放
        if isOnlineSource(self.currentUrl!) {
            self.configManager?.playerStatus = .playing
            self.noNetworkView.isHidden = true
        } else {
            // 判断有没有网络
            if self.networkCode == 0 {
                self.noNetworkView.isHidden = true
            } else if self.networkCode != 1 { // 流量播放
                self.flowView.isHidden = true
                self.configManager?.playerStatus = .playing
            } else {
                self.configManager?.playerStatus = .playing
            }
        }
        
        print("status: \(self.configManager?.playerStatus)")
        print("networkCode: \(self.networkCode)")
        
        // 继续播放, TODO
        if config.playContinue {
            
        }
    }
    
    // 判断是否网上资源
    private func isOnlineSource(_ url: String) -> Bool {
        return url.starts(with: "http://") || url.starts(with: "https://")
    }
    
    // 创建没有网络情况下的提示
    private func createNoNetworkView() {
        noNetworkView = NoNetworkView()
        noNetworkView.isHidden = true
        self.addSubview(noNetworkView)
    }
    
    // 创建浏量播放视图
    private func createFlowView() {
        flowView = UIView()
        flowView.isHidden = true
        self.addSubview(flowView)
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
 
    // 更新配置
    func updatePlayerConfig(_ config: PlayerConfig) {
        DispatchQueue.global().async {
            if let oldConfig = self.configManager?.playerConfig {
                if oldConfig.audioUrl != config.audioUrl || oldConfig.videoUrl != config.videoUrl {
                    self.configManager?.playerConfig = config
                }
            } else {
                self.configManager?.playerConfig = config
            }
        }
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
