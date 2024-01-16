// 定义一些属性

import UIKit

class BasicUtils {
    
    // 资源文件
    static let SOURCE_BUNDLE = Bundle.init(path: Bundle.main.path(forResource: "Player/icons", ofType: nil)!)
    
    // 视频高度
    static let VIDEO_HEIGHT: CGFloat = 405
    
    // 播放器面板高度
    static let PLAYER_CONTROL_PANEL_HEIGHT: CGFloat = 40
    
    // 全屏播放器面板高度
    static let PLAYER_FULLSCREEN_CONTROL_PANEL_HEIGHT: CGFloat = 110
    
    // 全屏播放器左侧或右侧空的位置
    static let PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING: CGFloat = 20
    
    // 全屏播放器左侧或右侧空的位置
    static let PLAYER_FULLSCREEN_TOP_OR_BOTTOM_PADDING: CGFloat = 20
    
    // 播放器左侧或右侧空的位置
    static let PLAYER_LEFT_OR_RIGHT_PADDING: CGFloat = 10
    
    // 自定义导航条高度
    static let CUSTOM_NAVIGATION_HEIGHT: CGFloat = 64
    
    // 倍速列表
    static let speedList: [Float] = [0.5, 0.75, 1, 1.25, 1.5, 2, 3]
    
    // 判断是不是 X 系列手机
    static var IS_PHONEX: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return false
        }
        
        let size = UIScreen.main.bounds.size
        let notchValue = Int(size.width / size.height * 100)
        
        if 216 == notchValue || 46 == notchValue {
            return true
        }
        
        guard #available(iOS 11.0, *) else {
            return false
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let bottomHeight = windowScene.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottomHeight > 30
        }
        
        return false
    }
    
    // 获取屏幕宽度
    static func getScreenWidth() -> Double {
        return UIScreen.main.bounds.size.width
    }
    
    // 获取屏幕高度
    static func getScreenHeight() -> Double {
        return UIScreen.main.bounds.size.height
    }
    
    // 获取播放器宽度
    static func getPlayerWidth() -> Double {
        return getScreenWidth() / 16 * 9
    }
}
