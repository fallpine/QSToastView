//
//  QSAppearance.swift
//  QSToastView
//
//  Created by Mac on 2022/4/24.
//

import UIKit

public class QSAppearance {
    // 是否需要遮罩层，默认 需要
    var isMask: Bool = true
    // 遮罩层颜色，默认 透明
    var maskColor: UIColor = .clear
    // 吐司颜色，默认 黑色半透明
    var toastColor: UIColor = .init(red: 0, green: 0, blue: 0, alpha: 0.6)
    // 吐司圆角，默认 10.0
    var toastCornerRadius: CGFloat = 10.0
    // 成功图片颜色，默认 绿色
    var successImgColor: UIColor = .green
    // 失败图片颜色，默认 红色
    var errorImgColor: UIColor = .red
    // 等待图片颜色，默认 白色
    var waitImgColor: UIColor = .white
    // 文字颜色，默认 白色
    var textColor: UIColor = .white
    // 文字字体
    var textFont: UIFont = .systemFont(ofSize: 14.0)
}
