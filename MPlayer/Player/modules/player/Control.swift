// 播放器控制面板

import UIKit

struct Point {
    var width: CGFloat
    var height: CGFloat
}

class PlayerControlView: UIView {
    
    // 播放|暂停按钮
    package var playButton: MButton!
    
    // 全屏按钮
    package var fullscreenButton: MButton!
    
    // 播放器播放时间显示条
    private var playerTimeLabel: UILabel!
    
    // 播放器总时间显示条
    private var totalTimeLabel: UILabel!
    
    // 播放器时间进度滑动条
    package var timeSlider: UISlider!
    
    // 缓存进度条
    private var cacheView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initProps()
        self.initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化一些属性
    private func initProps() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    }
    
    // 初始化 views
    private func initViews() {
        let bounds = self.bounds
        print("player bounds: \(bounds)")
        
        // 播放|暂停按钮
        let playButtonPoint = Point(width: 40, height: 40)
        playButton = MButton()
        playButton.setImage(imageName: VIDEO_PLAY_BUTTON_IMAGE_NAME)
        playButton.frame = CGRectMake(0, 0, playButtonPoint.width, playButtonPoint.height)
        addSubview(playButton)
        
        // 全屏按钮
        let fullscreenButtonPoint = Point(width: 40, height: 30)
        fullscreenButton = MButton()
        fullscreenButton.setImage(imageName: PLAYER_FULLSCREEN_IMAGE_NAME)
        fullscreenButton.frame = CGRectMake(bounds.size.width - fullscreenButtonPoint.width, bounds.size.height - 5 - fullscreenButtonPoint.height, fullscreenButtonPoint.width, fullscreenButtonPoint.height)
        addSubview(fullscreenButton)
        
        // 播放时间
        let playerTimeLabelPoint = Point(width: 40, height: 40)
        playerTimeLabel = UILabel()
        playerTimeLabel.text = "00:00"
        playerTimeLabel.font = UIFont.boldSystemFont(ofSize: 13)
        playerTimeLabel.textColor = .white
        playerTimeLabel.frame = CGRectMake(playButton.frame.maxX + 8, (bounds.height - playerTimeLabelPoint.height) / 2, playerTimeLabelPoint.width, playerTimeLabelPoint.height)
        addSubview(playerTimeLabel)
        
        
        // 播放器时间显示条
        let totalTimeLabelPoint = Point(width: 40, height: 40)
        totalTimeLabel = UILabel()
        totalTimeLabel.text = "00:00"
        totalTimeLabel.font = UIFont.boldSystemFont(ofSize: 13)
        totalTimeLabel.textColor = .white
        totalTimeLabel.frame = CGRectMake(fullscreenButton.frame.minX - 8 - totalTimeLabelPoint.width, (bounds.height - totalTimeLabelPoint.height) / 2, totalTimeLabelPoint.width, totalTimeLabelPoint.height)
        addSubview(totalTimeLabel)
        
        // 播放器时间进度滑动条
        timeSlider = UISlider()
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = 1
        timeSlider.minimumTrackTintColor = .white
        timeSlider.maximumTrackTintColor = .white.withAlphaComponent(0.4)
        timeSlider.setThumbImage(UIImage(named: PLAYER_TIME_SLIDER_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil), for: .normal)
        
        // 计算 x, y, width, height
        let timeSliderLeft = playerTimeLabel.frame.maxX + 8
        let timeSilderRight = totalTimeLabel.frame.minX - 8
        let timeSliderWidth = timeSilderRight - timeSliderLeft
        timeSlider.frame = CGRectMake(timeSliderLeft, 0, timeSliderWidth, bounds.height)
        addSubview(timeSlider)
        
        // 缓存进度条
        cacheView = UIView()
        cacheView.backgroundColor = .white.withAlphaComponent(0.5)
        cacheView.frame = CGRectMake(48, 20, 0, 1)
        // addSubview(cacheView)
    }

}

// MARK: 对外一些事件
extension PlayerControlView {
    
    // 更新 Label 信息
    package func updateLabel(_ playerTime: String, _ totalTime: String) {
        if !playerTime.isEmpty {
            playerTimeLabel.text = playerTime
        }
        
        if !totalTime.isEmpty {
            totalTimeLabel.text = totalTime
        }
    }
    
    // 更新播放图标, 根据 PlayerStatus
    package func updatePlayImage(_ image: UIImage) {
        playButton.setImage(image, for: .normal)
    }
    
    // 设置滑动条的值
    package func updateTimeSliderValue(_ value: Float) {
        timeSlider.value = value
    }
}
