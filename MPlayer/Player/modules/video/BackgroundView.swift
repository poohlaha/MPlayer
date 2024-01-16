// 播放器底部背景

import UIKit

class BackgroundView: UIView {
    
    var view: UIView!
    private var cacheView: UIView
    
    init(bounds: CGRect, cacheView: UIView) {
        self.cacheView = cacheView
        super.init(frame: bounds)
        
        view = UIView()
        view.isHidden = true // 设置隐藏
        view.isUserInteractionEnabled = true // 设置不可点击
        
        // 手势
        let hiddenTap = UITapGestureRecognizer(target: self, action: #selector(removeCacheView))
        view.addGestureRecognizer(hiddenTap)
        view.backgroundColor = .black
        view.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 隐藏缓存列表
    @objc private func removeCacheView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
            self.cacheView.frame = CGRect(x: 0, y: BasicUtils.getScreenWidth(), width: BasicUtils.getScreenHeight(), height: BasicUtils.VIDEO_HEIGHT)
        }) { (success) in
            self.view.isHidden = true
            self.cacheView.removeFromSuperview()
        }
    }
}
