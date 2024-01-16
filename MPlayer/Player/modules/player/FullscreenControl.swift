// 全屏下的进度条

import UIKit

class FullscreenControl: UIView {
    
    // 播放|暂停按钮
    package var playButton: MButton!
    
    // 播放器播放时间显示条
    private var playerTimeLabel: UILabel!
    
    // 播放器总时间显示条
    private var totalTimeLabel: UILabel!
    
    // 播放器时间进度滑动条
    package var timeSlider: UISlider!
    
    // 缓存进度条
    private var cacheView: UIView!
    
    // 倍速标签
    private var speedLabel: UILabel!
    
    // 底部按钮
    private var buttonsView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化一些属性
        self.initProps()
        
        // 创建视图
        self.createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化一些属性
    private func initProps() {
        self.clipsToBounds = true
        self.backgroundColor = .clear
    }
    
    // 创建视图
    private func createViews() {
       
        // 创建按钮类视图
        createButtonsView()
        
        // 创建进度条视图
        createSliderView()
    }
    
    // 创建按钮类视图
    private func createButtonsView() {
        // 按钮视图
        buttonsView = UIView()
        buttonsView.frame = CGRectMake(BasicUtils.PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING, self.bounds.height - 40 - BasicUtils.PLAYER_FULLSCREEN_TOP_OR_BOTTOM_PADDING, self.bounds.width - BasicUtils.PLAYER_FULLSCREEN_TOP_OR_BOTTOM_PADDING * 2, 40)
        buttonsView.backgroundColor = .clear
        addSubview(buttonsView)
        
        // 播放|暂停按钮
        let playButtonPoint = Point(width: 30, height: 30)
        playButton = MButton()
        playButton.setImage(PLAYER_CONTROL_PLAY_BUTTON_IMAGE_NAME)
        playButton.frame = CGRectMake(BasicUtils.PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING, (buttonsView.bounds.height - playButtonPoint.width) / 2, playButtonPoint.width, playButtonPoint.height)
        buttonsView.addSubview(playButton)
        
        // 倍速
        let speedLabelPoint = Point(width: 40, height: 50)
        speedLabel = UILabel()
        speedLabel.text = "倍速"
        speedLabel.font = UIFont.boldSystemFont(ofSize: 18)
        speedLabel.textColor = .white
        speedLabel.frame = CGRectMake(buttonsView.bounds.width - speedLabelPoint.width - BasicUtils.PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING, (buttonsView.bounds.height - speedLabelPoint.height) / 2, speedLabelPoint.width, speedLabelPoint.height)
        buttonsView.addSubview(speedLabel)
        
        // ... 其他一些按钮, TODO
    }
    
    // 创建进度条视图
    private func createSliderView() {
        // 播放器时间进度滑动条
        timeSlider = UISlider()
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = 1
        timeSlider.minimumTrackTintColor = .white
        timeSlider.maximumTrackTintColor = .white.withAlphaComponent(0.4)
        timeSlider.setThumbImage(UIImage(named: PLAYER_TIME_SLIDER_IMAGE_NAME, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil), for: .normal)
        timeSlider.frame = CGRectMake(BasicUtils.PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING * 2, buttonsView.frame.minY - BasicUtils.PLAYER_FULLSCREEN_TOP_OR_BOTTOM_PADDING, self.bounds.width - BasicUtils.PLAYER_FULLSCREEN_TOP_OR_BOTTOM_PADDING * 4, 10)
        addSubview(timeSlider)
        
        // 播放时间
        let playerTimeLabelPoint = Point(width: 60, height: 30)
        playerTimeLabel = UILabel()
        playerTimeLabel.text = "00:00"
        playerTimeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        playerTimeLabel.textColor = .white
        playerTimeLabel.frame = CGRectMake(BasicUtils.PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING * 2, timeSlider.frame.minY - 7 - playerTimeLabelPoint.height, playerTimeLabelPoint.width, playerTimeLabelPoint.height)

        addSubview(playerTimeLabel)
        
        // 播放器时间显示条
        let totalTimeLabelPoint = Point(width: 60, height: 30)
        totalTimeLabel = UILabel()
        totalTimeLabel.text = "00:00"
        totalTimeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        totalTimeLabel.textColor = .white
        totalTimeLabel.frame = CGRectMake(self.bounds.width - BasicUtils.PLAYER_FULLSCREEN_LEFT_OR_RIGHT_PADDING * 2 - playerTimeLabelPoint.width, timeSlider.frame.minY - 7 - playerTimeLabelPoint.height, totalTimeLabelPoint.width, totalTimeLabelPoint.height)
        addSubview(totalTimeLabel)
    }
}
