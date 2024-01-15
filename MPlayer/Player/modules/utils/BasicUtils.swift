// 定义一些属性

import UIKit

class BasicUtils {
    
    // 资源文件
    static let SOURCE_BUNDLE = Bundle.init(path: Bundle.main.path(forResource: "Player/icons", ofType: nil)!)
    
    // 屏幕宽度
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    
    // 屏幕高度
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    // 播放器宽度
    static let PLAYER_WIDTH = SCREEN_WIDTH / 16 * 9
    
    // 视频高度
    static let VIDEO_HEIGHT: CGFloat = 405
    
    // 播放器面板高度
    static let PLAYER_CONTROL_PANEL_HEIGHT: CGFloat = 40
    
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
}
