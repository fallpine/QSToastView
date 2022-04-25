//
//  UIBezierPath+Qs.swift
//  QSToastView
//
//  Created by Mac on 2022/4/24.
//

import UIKit

extension UIBezierPath {
    /// 画一个对钩
    class func drawSuccessImage(size: CGSize, color: UIColor) {
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x: size.width * 5.0 / 40.0, y: size.height * 16.0 / 30.0))
        path.addLine(to: CGPoint.init(x: size.width * 15.0 / 40.0, y: size.height * 25.0 / 30.0))
        path.addLine(to: CGPoint.init(x: size.width * 35.0 / 40.0, y: size.height * 5.0 / 30.0))
        path.lineWidth = 5.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        color.setStroke()
        path.stroke()
    }
    
    /// 画一个叉
    class func drawErrorImage(size: CGSize, color: UIColor) {
        let path1 = UIBezierPath.init()
        path1.move(to: CGPoint.init(x: size.width * 5.0 / 30.0, y: size.height * 5.0 / 30.0))
        path1.addLine(to: CGPoint.init(x: size.width * 25.0 / 30.0, y: size.height * 25.0 / 30.0))
        path1.lineWidth = 5.0
        path1.lineCapStyle = .round
        path1.lineJoinStyle = .round
        
        let path2 = UIBezierPath.init()
        path2.move(to: CGPoint.init(x: size.width * 25.0 / 30.0, y: size.height * 5.0 / 30.0))
        path2.addLine(to: CGPoint.init(x: size.width * 5.0 / 30.0, y: size.height * 25.0 / 30.0))
        path2.lineWidth = 5.0
        path2.lineCapStyle = .round
        path2.lineJoinStyle = .round
        
        path1.append(path2)
        color.setStroke()
        path1.stroke()
    }
    
    /// 画一个半圆
    class func drawWaitImage(size: CGSize, color: UIColor) {
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: size.width / 2.0, y: size.height / 2.0), radius: size.width / 2.0 - 5.0, startAngle: 0.0, endAngle: Double.pi * 4.0 / 3.0, clockwise: true)
        path.lineWidth = 5.0
        path.lineCapStyle = .round
        color.setStroke()
        path.stroke()
    }
}
