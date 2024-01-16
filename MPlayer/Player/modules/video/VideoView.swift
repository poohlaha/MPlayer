// 播放器

import UIKit

class VideoView: UIView {
    
    // 事件管理
    private var manager: AudioManager?
    
    // 视图大小
    private var size: CGRect?
    
    // 播放配置
    private var config: PlayerConfig!
    
    // 播放控制面板 view
    package var playerPanelView: PlayerPanelView!
    
    package var otherView: OtherView!
    
    // 网络
    private var networkManager = NetworkManager()
    
    // 网络状态码
    private var networkCode: Int = 0
    
    // 初始化
    init(_ frame: CGRect?, _ config: PlayerConfig, _ backgroundColor: UIColor?) {
        // 初始化 size
        let bounds: CGRect
        if frame == nil {
            bounds = CGRectMake(0, 0, BasicUtils.getScreenWidth(), BasicUtils.getPlayerWidth()) // 宽度的 16 比 9
        } else {
            bounds = frame!
        }
        
        print("bounds: \(bounds)")
        super.init(frame: bounds)
        self.size = bounds
        self.config = config
        
        initView(backgroundColor)
        initProps()
        
        // 创建 views
        createViews()
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
        
        // 获取网络状态码
        getNetworkCode()
        
        UIApplication.shared.isIdleTimerDisabled = true // 开启屏幕常量
    }
    
    // 创建基础视图
    private func createViews() {
        // 创建黑色背景底色
        // createBackgroundView()

        
        // 创建敀器控制面板
        createPlayerControlPanel()
        
        // 创建其他视图
        // createOtherView()
    }
    
    // 创建黑色背景底色
    private func createBackgroundView() {
        // 创建黑色背景底色
        let baseView = UIView()
        baseView.backgroundColor = .black
        baseView.frame = self.size ?? CGRect.zero
        self.addSubview(baseView)
    }
    
    // 创建播放器控制面板
    private func createPlayerControlPanel() {
        playerPanelView = PlayerPanelView(self.bounds, self.config)
        addSubview(playerPanelView)
    }
    
    // 创建其他视图
    private func createOtherView() {
        otherView = OtherView(self.bounds)
        addSubview(otherView)
    }

    // 获取网络状态码
    private func getNetworkCode() {
        networkManager.setup { code in
            print("get code: \(code)")
            self.networkCode = 1 // todo
        }
    }
    
}
