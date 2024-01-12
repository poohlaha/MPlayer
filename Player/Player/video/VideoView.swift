// 播放器

import UIKit

class VideoView: UIView {
    
    // 视频 view
    var videoView: PlayerView!
    
    // 背景图, 在视频加载前显示
    private var backgroundImageView: UIImageView!
    
    // 结束背景图
    private var playEndView: PlayEndView?
    
    // 事件管理
    private var manager: AudioManager?
    
    // 播放器快捷操作
    private var playerManager: PlayerManager?
    
    // 没有网络提示
    private var noNetworkView: NoNetworkView!
    
    // 视图大小
    private var size: CGRect?
    
    private var config: PlayerConfig!
    
    init(_ frame: CGRect?, _ config: PlayerConfig, _ backgroundColor: UIColor?) {
        // 初始化 size
        let bounds: CGRect
        if frame == nil {
            bounds = CGRectMake(0, 0, BasicUtils.SCREEN_WIDTH, BasicUtils.PLAYER_WIDTH) // 宽度的 16 比 9
        } else {
            bounds = frame!
        }
        
        print("bounds: \(bounds)")
        super.init(frame: bounds)
        self.size = bounds
        self.config = config
        
        initView(backgroundColor)
        initProps()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化大小
    private func initView(_ backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor ?? .black
        self.clipsToBounds = true // 超出边界后会被裁剪
        self.frame = self.size!

    }
    
    // 初始化属性
    private func initProps() {
        self.manager = AudioManager(self)
        self.playerManager = PlayerManager(self)
        
        createViews()
    }
    
    // 创建基础视图
    private func createViews() {
        // 创建黑色背景底色
        // createBackgroundView()
        
        // 创建视频视图
        createVideoView()
        
        // 创建背景图片
        // createBackgroundImageView()
        
        // 创建控制面板
        // createControlPanel()
        
        // 创建结束视图
        // createEndPlayView()
        
        // 创建没有网络情况下的提示
        // createNoNetworkView()
    }
    
    // 创建黑色背景底色
    private func createBackgroundView() {
        // 创建黑色背景底色
        let baseView = UIView()
        baseView.backgroundColor = .black
        baseView.frame = self.size ?? CGRect.zero
        self.addSubview(baseView)
    }
    
    
    // 创建视频视图, 添加手势
    private func createVideoView() {
        videoView = PlayerView(self.size!)
        videoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerViewDidTapped)))
        videoView.clipsToBounds = true
        videoView.updatePlayerConfig(self.config)
        
        print("video view size \(self.size!)")
        self.addSubview(videoView)
    }
    
    // 创建背景图片
    private func createBackgroundImageView() {
        backgroundImageView = UIImageView()
        backgroundImageView.isHidden = true
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.bounds = self.bounds
        addSubview(backgroundImageView)
    }
    
    // 创建控制面板
    private func createControlPanel() {
        
    }
    
    // 创建结束视图
    private func createEndPlayView() {
        
    }
    
    // 创建没有网络情况下的提示
    private func createNoNetworkView() {
        noNetworkView = NoNetworkView()
        noNetworkView.isHidden = true
    }
    
    // 点击屏幕，显示控制面板
    @objc private func playerViewDidTapped() {
        
    }
}
