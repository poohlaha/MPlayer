// 设备全屏 view

import UIKit

struct ImagePoint {
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
}

protocol FullscreenViewDelegate: NSObjectProtocol {
    
    // 更改倍速
    func changeSpeed()

}

class FullscreenNavigationBarView: UIView {
    
    // 导航栏标题
    private var titleLabel: UILabel!
    
    // 更多功能
    private var moreButton: MButton!
    
    // 返回按钮
    private var backButton: MButton!
    
    // 投屏按钮
    private var castScreenButton: MButton!
    
    // 屏幕锁定旋转按钮
    private var orientationRotateLockButton: MButton!
    
    // 标题
    private var title: String?
    
    // 初始化
    init(_ frame: CGRect, _ title: String) {
        super.init(frame: frame)
        
        // 初始化一些属性
        initProps()
        
        // 创建视图
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化一些属性
    private func initProps() {
        self.backgroundColor = .clear
    }
    
    // 创建视图
    private func createViews() {
        let paddingLeft: CGFloat = BasicUtils.PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING
        
        // 返回按钮
        var backButtonPoint = ImagePoint(x: paddingLeft, y: 0, width: 30, height: 30)
        backButtonPoint.y = getPointY(backButtonPoint.height)
        
        backButton = MButton()
        backButton.setImage(BACK_BUTTON_IMAGE_NAME)
        backButton.frame = CGRectMake(backButtonPoint.x, backButtonPoint.y, backButtonPoint.width, backButtonPoint.height)
        addSubview(backButton)
        
        // 导航栏标题
        var titleLabelPoint = ImagePoint(x: backButtonPoint.x + backButtonPoint.width + paddingLeft, y: 0, width: 200, height: self.bounds.height)
        
        titleLabel = UILabel()
        titleLabel.text = self.title ?? ""
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.frame = CGRectMake(titleLabelPoint.x, titleLabelPoint.y, titleLabelPoint.width, titleLabelPoint.height)
        addSubview(titleLabel)
        
        // 更多功能
        var moreButtonPoint = ImagePoint(x: 0, y: 0, width: 40, height: 30)
        moreButtonPoint.x = self.bounds.width - paddingLeft - moreButtonPoint.width
        moreButtonPoint.y = getPointY(moreButtonPoint.height)
        
        moreButton = MButton()
        moreButton.setImage(MORE_BUTTON_IMAGE_NAME)
        moreButton.frame = CGRectMake(moreButtonPoint.x, moreButtonPoint.y, moreButtonPoint.width, moreButtonPoint.height)
        addSubview(moreButton)
        
        // 锁定屏幕旋转按钮
        var orientationRotateLockButtonPoint = ImagePoint(x: moreButtonPoint.x - moreButtonPoint.width - paddingLeft, y: 0, width: 30, height: 30)
        orientationRotateLockButtonPoint.y = getPointY(orientationRotateLockButtonPoint.height)
        
        orientationRotateLockButton = MButton()
        orientationRotateLockButton.setImage(PLAYER_FULLSCREEN_LOCK_ROTATE_IMAGE_NAME)
        orientationRotateLockButton.frame = CGRectMake(orientationRotateLockButtonPoint.x, orientationRotateLockButtonPoint.y, orientationRotateLockButtonPoint.width, orientationRotateLockButtonPoint.height)
        addSubview(orientationRotateLockButton)
        
        // 投屏按钮
        var castScreenButtonPoint = ImagePoint(x: orientationRotateLockButtonPoint.x - orientationRotateLockButtonPoint.width - paddingLeft, y: 0, width: 30, height: 30)
        castScreenButtonPoint.y = getPointY(castScreenButtonPoint.height)
        
        castScreenButton = MButton()
        castScreenButton.setImage(PLAYER_FULLSCREEN_CAST_SCREEN_IMAGE_NAME)
        castScreenButton.frame = CGRectMake(castScreenButtonPoint.x, castScreenButtonPoint.y, castScreenButtonPoint.width, castScreenButtonPoint.height)
        addSubview(castScreenButton)
    }
    
    // 获取 Y 轴坐标点
    private func getPointY(_ height: CGFloat) -> CGFloat {
       return (self.bounds.height - height) / 2
    }
    
    // 设置标题
    package func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
}


// MARK: 属性
class FullscreenView: UIView {
    
    // delegate
    package weak var delegate: FullscreenViewDelegate?
    
    // 是否全屏锁定
    private var isScreenLock: Bool = false
    
    // 是否锁定设备旋转
    private var isOrientationRotateLock: Bool = false
    
    // 当前速度
    private var currentSpeed: Float = 1
    
    // 导航栏
    private var navigationBarView: FullscreenNavigationBarView!
  
    // 屏幕锁定按钮
    private var lockButton: MButton!
    
    // 更多功能
    private var morePanelView: FullscreenMoreView!
    
    // 当前画面: 0: 不铺满, 1: 铺满
    private var currentScreenStatus: Int = 0
    
    // 面板进度条
    private var controlView: FullscreenControl!
    
    // 初始化
    init(_ frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化一些属性
        initProps()
        
        // 创建视图
        createViews()
        
        // 创建导航栏视图
        createNavigationBarView()
        
        // 创建面板进度条view
        createControlView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 私有方法
extension FullscreenView {
    
    // 初始化一些属性
    private func initProps() {
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
    }
    
    // 创建视图
    private func createViews() {
        let paddingLeft: CGFloat = BasicUtils.PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING
        let centerY = (self.bounds.height) / 2 // 上下中心点位置
        
        // 锁定屏幕按钮
        var lockButtonPoint = ImagePoint(x: paddingLeft, y: 0, width: 30, height: 30)
        lockButtonPoint.y = centerY - lockButtonPoint.height
        
        lockButton = MButton()
        lockButton.setImage(PLAYER_FULLSCREEN_UNLOCK_IMAGE_NAME)
        lockButton.frame = CGRectMake(lockButtonPoint.x, lockButtonPoint.y, lockButtonPoint.width, lockButtonPoint.height)
        addSubview(lockButton)
    }
    
    // 创建导航栏视图
    private func createNavigationBarView() {
        // 导航栏
        navigationBarView = FullscreenNavigationBarView(CGRectMake(0, 0, self.bounds.width, BasicUtils.CUSTOM_NAVIGATION_HEIGHT), "")
        addSubview(navigationBarView)
    }
    
    // 创建面板进度条view
    private func createControlView() {
        controlView = FullscreenControl(frame: CGRectMake(0, self.bounds.height - BasicUtils.PLAYER_FULLSCREEN_CONTROL_PANEL_HEIGHT, self.bounds.width, BasicUtils.PLAYER_FULLSCREEN_CONTROL_PANEL_HEIGHT))
        addSubview(controlView)
        print("control frame \(controlView.frame)")
    }
}

// MARK: 对外方法
extension FullscreenView {
    
    // 设置标题
    package func setTitle(_ title: String) {
        self.navigationBarView.setTitle(title)
    }
    
    // 是否为锁定屏幕
    package func getIsScreenLock() -> Bool {
        return self.isScreenLock
    }
    
    // 是否为锁定旋转屏幕
    package func getIsOrientationRotateLock() -> Bool {
        return self.isOrientationRotateLock
    }
}
