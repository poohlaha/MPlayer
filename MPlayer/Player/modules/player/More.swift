// 更多功能，分为全屏和非全屏

import UIKit

// 全屏
class FullscreenMoreView: UIView {
    
    // 下载按钮
    private var downloadButton: MButton!
    
    // 循环播放
    private var loopPlayButton: MButton!
    
    // 定时关闭
    private var scheduledShutdownButton: MButton!
    
    // 撑满全屏 | 不撑满全屏
    private var coveredFullscreenButton: MButton!
    
    private var pictureInPictureButton: MButton!
}

// 非全屏
class MoreView: UIView {
    
}


