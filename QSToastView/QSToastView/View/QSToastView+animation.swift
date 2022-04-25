//
//  QSToastView+animation.swift
//  QSToastView
//
//  Created by Mac on 2022/4/25.
//

import UIKit

extension QSToastView {
    /// 旋转动画
    func startRotationAnimation(with view: UIView) {
        // 创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 1.2
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        rotationAnim.isRemovedOnCompletion = false
        
        // 将动画添加到layer中
        view.layer.add(rotationAnim, forKey: "rotation")
    }
}
