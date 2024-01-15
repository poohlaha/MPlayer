// 其他一些 views, 如背景、网络、开始、结束等view

import UIKit

class OtherView: UIView {
    
    private var backgroundView: UIImageView!
    
    // 开始背景图
    private var playStartView: UIView?
    
    // 结束背景图
    private var playEndView: UIView?
    
    // 没有网络 view
    private var noNetworkView: UIView!
    
    // 初始化
    init(_ frame: CGRect) {
        super.init(frame: frame)

        // 创建 views
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 创建视频
    private func createViews() {
        // 创建背景图片
        // createBackgroundImageView()
        
        // 创建结束视图
        // createEndPlayView()
        
        // 创建没有网络情况下的提示
        // createNoNetworkView()
    }
    
    // 创建背景图片
    private func createBackgroundImageView() {
        backgroundView = UIImageView()
        backgroundView.isHidden = true
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        backgroundView.bounds = self.bounds
        addSubview(backgroundView)
    }

    
    // 创建结束视图
    private func createEndPlayView() {
        
    }
    
    
     // 创建没有网络情况下的提示
     private func createNoNetworkView() {
         noNetworkView = UIView()
         noNetworkView.isHidden = true
         self.addSubview(noNetworkView)
     }
}
