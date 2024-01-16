// 播放器面板，包括视频 view、控制面板

import UIKit
import AVFoundation
import MediaPlayer

class PlayerPanelView: UIView {
    
    // 视频 view
    package var videoView: PlayerView!
    
    // 播放控制面板
    private var controlView: PlayerControlView!
    
    // 播放定时器
    private var playerTimer: Timer?
    
    // 视频配置
    private var config: PlayerConfig!
    
    // 播放器控制中心
    private var manager: PlayerManager!
    
    // 流量播放弹框
    private var flowView: UIView!
    
    // 网络状态码
    private var networkCode: Int = 1
    
    // 没有网络时的视图
    private var noNetworkView: NoNetworkView!
    
    // 全屏时的视频
    private var fullscreenView: FullscreenView?
    
    // 初始化
    init(_ frame: CGRect, _ config: PlayerConfig) {
        super.init(frame: frame)
        
        self.config = config
        
        // 初始化属性
        initProps()
        
        // 创建 views
        createViews()
        
        // 注册事件
        initEvents()
        
        // 初始化监听事件
        inintListeners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化一些属性
    func initProps() {
        self.manager = PlayerManager(self)
    
        // 设置播放定时器
       createPlayerTimer()
    }
  
    // 创建定时器
    private func createPlayerTimer() {
        playerTimer?.invalidate()
        playerTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatePlayerControlPanel(sender:)), userInfo: nil, repeats: true)
    }
    
    // 创建 views
    private func createViews() {
        // 创建视频 view
        createVideoView()
        
        // 创建播放器控制面板 view
        createControlView()
        
        // 创建流量播放视图
        createFlowView()
        
        // 创建全屏播放视频
        createFullscreenView()
    }
    
    // 创建视频 view
    private func createVideoView() {
        videoView = PlayerView(self.bounds, self.networkCode != 0)
        videoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerViewDidTapped)))
        videoView.clipsToBounds = true
        self.updatePlayerConfig(self.config)
        addSubview(videoView)
    }
    
    // 创建播放器控制面板
    private func createControlView() {
        let frame = CGRectMake(0, self.bounds.height - BasicUtils.PLAYER_CONTROL_PANEL_HEIGHT, self.bounds.width, BasicUtils.PLAYER_CONTROL_PANEL_HEIGHT)
        controlView = PlayerControlView(frame: frame)
        addSubview(controlView)
    }
    
    // 创建流量播放视图
    private func createFlowView() {
        flowView = UIView()
        flowView.isHidden = true
        self.addSubview(flowView)
    }
    
    // 创建全屏视图
    private func createFullscreenView() {
        fullscreenView = FullscreenView(CGRectMake(0, 0, BasicUtils.getScreenHeight(), BasicUtils.getScreenWidth()))
        fullscreenView?.delegate = self
        fullscreenView?.isHidden = true
        addSubview(fullscreenView!)
    }
    
    // 注册事件
    func initEvents() {
        controlView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        controlView.fullscreenButton.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)
        controlView.timeSlider.addTarget(self, action: #selector(timeSliderTouchUp(_:)), for: .touchUpInside)
        controlView.timeSlider.addTarget(self, action: #selector(timeSliderTouchUp(_:)), for: .touchUpOutside)
        controlView.timeSlider.addTarget(self, action: #selector(timeSliderDown(_:)), for: .touchDown)
        controlView.timeSlider.addTarget(self, action: #selector(timeSliderDraging(_:)), for: .valueChanged)
    }
    
    // 初始化监听事件
    func inintListeners() {
        // 监听设备旋转
        NotificationCenter.default.addObserver(self,  selector: #selector(listenDeviceRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
   
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Delegate
extension PlayerPanelView: FullscreenViewDelegate {
    
    // 更改速度
    func changeSpeed() {
        
    }
    
}

// MARK: 播放器的一些事件
extension PlayerPanelView {
    
    // 播放视频
    func playVideo(_ config: PlayerConfig) {
        DispatchQueue.main.async {
            self.videoView.initWithConfig(config)
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
        videoView.play(url, config) { item in
            DispatchQueue.main.async {
                self.playVideo(item, config)
            }
        }
    }
    
    // 播放视频
    private func playVideo(_ item: AVPlayerItem, _ config: PlayerConfig) {
        self.videoView.playVideo(item, config)
        
        // 查看没有网络 view
        // noNetworkView.isHidden = self.networkCode != 0
        
        // 查看是否有缓存
        // TODO
        
        // 如果是本地资源, 直接播放
        if self.videoView.isOnlineSource {
            self.manager.setPlayerStatus(.playing)
            // self.noNetworkView.isHidden = true
        } else {
            // 判断有没有网络
            if self.networkCode == 0 {
                // self.noNetworkView.isHidden = true
            } else if self.networkCode != 1 { // 流量播放
                // self.flowView.isHidden = true
                self.manager.setPlayerStatus(.playing)
            } else {
                self.manager.setPlayerStatus(.playing)
            }
        }
        
        // 继续播放, TODO
        if config.playContinue {
            
        }
    }
    
    // 点击屏幕，显示控制面板
    @objc private func playerViewDidTapped() {
        
    }
    
    // 播放|暂停按钮点击事件
    @objc private func playButtonTapped() {
        print("PlayButton Tapped")
        guard let playStatus = self.manager.getPlayerStatus() else {
            return
        }
        
        if playStatus == .playing {
            pause()
            return
        }
       
        if playStatus == .pause {
            play()
        }
    }
    
    // 全屏按钮点击事件
    @objc private func fullscreenButtonTapped() {
        print("FullscreenButton Tapped")
        changeOrientation()
    }
    
    // 播放进度条抬起
    @objc private func timeSliderTouchUp(_ sender: UISlider) {
        print("timeSliderTouchUp: \(sender.value)")
        changeSliderProgress(sender.value)
        play()
    }
    
    // 播放进度条按下
    @objc private func timeSliderDown(_ sender: Any) {
        print("TimeSlider Down")
        pause()
    }
    
    // 播放进度条拖拽
    @objc private func timeSliderDraging(_ sender: UISlider) {
        print("timeSliderDraging: \(sender.value)")
        self.updatePlayerControlPanel(sender.value)
    }
    
    // 更新播放控制面板事件
    @objc private func updatePlayerControlPanel(sender: Timer) {
        updatePlayerControlPanel()
    }
    
    // 更新控制面板
    private func updatePlayerControlPanel(_ progress: Float? = nil) {
        guard let currentTime = self.videoView?.getVideoPlayer()?.currentItem?.currentTime().seconds,
              let timescale = self.videoView?.getVideoPlayer()?.currentTime().timescale,
              let duration = self.videoView?.getVideoPlayer()?.currentItem?.duration.seconds,
            !currentTime.isNaN && !duration.isNaN
            else {
                return
        }
        
        let totalMinute = Int(duration / 60) // 总时长的分钟部分
        let totalSeconds = Int(duration.truncatingRemainder(dividingBy: 60)) // 总时长的秒钟部分
        let currentMinute = Int(currentTime / 60) // 当前时长的分钟部分
        let currentSeconds = Int(currentTime.truncatingRemainder(dividingBy: 60))// 当前时长的秒钟部分
        
        // 总时长
        let playerTime = String(format: "%.2i:%.2i", currentMinute, currentSeconds)
        
        // 播放时长
        let totalTime = String(format: "%.2i:%.2i", totalMinute, totalSeconds)
        
        // 更新播放器控制面板时长
        self.controlView.updateLabel(playerTime, totalTime)
        
        // 更新进度条
        if let progress = progress {
           let time = CMTime(seconds: duration * Double(progress), preferredTimescale: timescale)
            self.videoView.setSeek(time)
            print("time: \(duration * Double(progress))")
        } else {
            self.controlView.updateTimeSliderValue(Float(currentTime) / Float(duration))
            print("update slider value: \(Float(currentTime) / Float(duration))")
        }
    }
    
    // 改变播放器进度条
    private func changeSliderProgress(_ progress: Float) {
        // self.updatePlayerControlPanel()
        
        let timescale = self.videoView?.getVideoPlayer()?.currentTime().timescale
        let duration = self.videoView?.getVideoPlayer()?.currentItem?.duration.seconds
        if let timescale = timescale, let duration = duration {
            if duration.isNaN {
                return
            }
            
            let currentTime: Double
            if progress < 1 {
                currentTime = Double(progress) * duration
            } else {
                currentTime = duration - 2
            }
            
            print("current time: \(currentTime)")
            let time = CMTime(seconds: currentTime, preferredTimescale: timescale)
            self.videoView.setSeek(time)
        }
    }
    
    // 设备旋转, orientationChange: 是否为设备旋转
    private func changeOrientation() {
        print("Change Orientation")
        // 判断是否已经是横屏
        let isHorizontalScreen = self.videoView.getIsHorizontalScreen()
        let orientation = UIDevice.current.orientation
        
        // 如果已经是横屏，并且是全屏状态，可直接不作处理
        if isHorizontalScreen && (orientation == .landscapeRight || orientation == .landscapeLeft) && self.videoView.getIsFullscreen() {
            return
        }
        
        let isFullScreen = self.videoView.judgeIsHorizontalScreen()
        self.videoView.setIsFullscreen(isFullScreen)
        
        if !self.videoView.getIsFullscreen() {
            fullscreenView?.isHidden = true
            return
        }
        
        handleFullscreen()
    }
    
    // 全屏处理
    private func handleFullscreen() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeRight {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        } else if orientation == .landscapeLeft {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        
        self.videoView.setFullFrame()
        fullscreenView?.isHidden = false
        fullscreenView?.setTitle(self.config.title ?? "")
        
        print("fullscreenView frame: \(fullscreenView?.frame)")
        print("videoView frame: \(videoView?.frame)")
        print("videoPlayerLayer frame: \(videoView?.getVideoPlayerLayer()?.frame)")
        
        // 隐藏竖屏控制面板
        controlView.isHidden = true
        
        removeFromSuperview()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let mainWindow = windowScene.windows.first {
            mainWindow.addSubview(self)
        }
        bringSubviewToFront(fullscreenView!)
    }
}

// MARK: 监听手机事件
extension PlayerPanelView {
    
    // 监听设备旋转
    @objc private func listenDeviceRotate() {
        print("device rotate")
        if fullscreenView === nil {
            return
        }
        
        // 判断是否为锁定屏幕 或 锁定屏幕旋转
        if fullscreenView!.getIsScreenLock() || fullscreenView!.getIsOrientationRotateLock() {
            return
        }
        
        print("rotate size: \(UIScreen.main.bounds)")
        changeOrientation()
    }
}

// MARK: 播放器事件
extension PlayerPanelView {
    
    // 更新配置
    func updatePlayerConfig(_ config: PlayerConfig) {
        DispatchQueue.global().async {
            if let oldConfig = self.manager?.getPlayerConfig() {
                if oldConfig.audioUrl != self.config.audioUrl || oldConfig.videoUrl != self.config.videoUrl {
                    self.manager.setPlayerConfig(self.config)
                }
            } else {
                self.manager.setPlayerConfig(self.config)
            }
        }
    }
    
    // 播放暂停
    func pause() {
        self.manager.setPlayerStatus(.pause)
        self.playerTimer?.invalidate()
    }
    
    // 继续播放
    func play() {
        self.manager.setPlayerStatus(.playing)
        self.createPlayerTimer()
    }
    
    // 重新播放
    func replay() {
        self.videoView.setSeek(CMTime(seconds: 0, preferredTimescale: 1))
        self.manager.setPlayerStatus(.playing)
    }
    
    // 获取 control view
    func getControlView() -> PlayerControlView {
        return self.controlView
    }
  
}
