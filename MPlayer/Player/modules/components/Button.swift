//
//  Button.swift
//  Player
//
//  Created by Smile on 2024/1/15.
//

import UIKit

class MButton: UIButton {
    
    // 判断触摸点是否在按钮的可点击区域内。
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        
        // 按钮的点击范围比原始按钮大了 10 个点的边界
        return CGRectMake(-10, -10, self.bounds.width + 20, self.bounds.height + 20).contains(point)
    }
    
    // 设置按钮图片
    func setImage(imageName: String) {
        self.setImage(UIImage(named: imageName, in: BasicUtils.SOURCE_BUNDLE, compatibleWith: nil), for: .normal)
    }
}
