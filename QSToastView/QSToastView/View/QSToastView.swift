//
//  QSToastView.swift
//  QSToastView
//
//  Created by Mac on 2022/4/24.
//

import UIKit

// 吐司类型
public enum QSToastType {
    case success    // 成功
    case error      // 失败
    case wait       // 等待
    case text       // 纯文本
}

class QSToastView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bgView)
        let bgViewLeft = NSLayoutConstraint.init(item: bgView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        let bgViewRight = NSLayoutConstraint.init(item: bgView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        let bgViewTop = NSLayoutConstraint.init(item: bgView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bgViewBottom = NSLayoutConstraint.init(item: bgView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraints([bgViewLeft, bgViewRight, bgViewTop, bgViewBottom])
        
        self.addSubview(contentView)
        let contentViewLeft = NSLayoutConstraint.init(item: contentView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1.0, constant: 80.0)
        let contentViewRight = NSLayoutConstraint.init(item: contentView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: self, attribute: .right, multiplier: 1.0, constant: -80.0)
        let contentViewCenterX = NSLayoutConstraint.init(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let contentViewCenterY = NSLayoutConstraint.init(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([contentViewLeft, contentViewRight, contentViewCenterX, contentViewCenterY])
        
        contentView.addSubview(iconImgView)
        let iconImgViewTop = NSLayoutConstraint.init(item: iconImgView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 12.0)
        let iconImgViewCenterX = NSLayoutConstraint.init(item: iconImgView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let iconImgViewLeft = NSLayoutConstraint.init(item: iconImgView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 12.0)
        iconImgViewLeft.priority = .defaultLow
        let iconImgViewRight = NSLayoutConstraint.init(item: iconImgView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -12.0)
        iconImgViewRight.priority = .defaultLow
        contentView.addConstraints([iconImgViewTop, iconImgViewCenterX, iconImgViewLeft, iconImgViewRight])
        
        contentView.addSubview(titleLab)
        let titleLabLeft = NSLayoutConstraint.init(item: titleLab, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 12.0)
        let titleLabRight = NSLayoutConstraint.init(item: titleLab, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -12.0)
        let titleLabBottom = NSLayoutConstraint.init(item: titleLab, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -12.0)
        titleLabTopConstraint = NSLayoutConstraint.init(item: titleLab, attribute: .top, relatedBy: .equal, toItem: iconImgView, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        let titleLabCenterX = NSLayoutConstraint.init(item: titleLab, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        contentView.addConstraints([titleLabLeft, titleLabRight, titleLabBottom, titleLabTopConstraint, titleLabCenterX])
    }
    
    /// 初始化
    /// - Parameter appearance: 样式
    convenience init(appearance: QSAppearance) {
        self.init()
        
        appearanceModel = appearance
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !appearanceModel.isMask {
            // 判断点是否在contentView上，不在contentView上，点击事件可穿透遮罩层
            let newPoint = self.convert(point, to: contentView)
            if contentView.hitTest(newPoint, with: event) != nil {
                return super.hitTest(point, with: event)
            }
            return nil
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    // MARK: - Func
    /// 显示
    /// - Parameters:
    ///   - view: 父视图
    ///   - toastType: 吐司类型
    ///   - interval: 显示时间，nil表示一直显示
    ///   - icon: 图标
    ///   - isIconRotate: 图标是否旋转
    ///   - title: 标题
    ///   - dismiss: 隐藏回调
    func showToast(in view: UIView?, toastType: QSToastType, interval: TimeInterval?, icon: String? = nil, isIconRotate: Bool = false, title: String = "", dismiss: (() -> ())?) {
        // 设置数据
        bgView.backgroundColor = appearanceModel.maskColor
        contentView.backgroundColor = appearanceModel.toastColor
        contentView.layer.cornerRadius = appearanceModel.toastCornerRadius
        contentView.layer.masksToBounds = true
        titleLab.textColor = appearanceModel.textColor
        titleLab.font = appearanceModel.textFont
        
        // 不是单纯显示文字
        if toastType != .text {
            if let iconName = icon {
                iconImgView.loadImage(iconName) { [weak self] size in
                    guard let `self` = self else { return }
                    
                    // 设置宽高
                    let iconImgViewWidth = NSLayoutConstraint.init(item: self.iconImgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: size.width)
                    let iconImgViewHeight = NSLayoutConstraint.init(item: self.iconImgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: size.height)
                    self.contentView.addConstraints([iconImgViewWidth, iconImgViewHeight])
                }
            } else {
                switch toastType {
                case .success:
                    iconImgView.image = successImage
                case .error:
                    iconImgView.image = errorImage
                case .wait:
                    iconImgView.image = waitImage
                case .text:
                    break
                }
            }
        }
        
        titleLab.text = title
        if title.isEmpty || toastType == .text {
            titleLabTopConstraint.constant = 0.0
        } else {
            titleLabTopConstraint.constant = 8.0
        }
        
        if isIconRotate {
            startRotationAnimation(with: iconImgView)
        }
        
        // 显示
        self.alpha = 0.0
        dismissAction = dismiss
        
        // 显示时间
        if let showTime = interval {
            dismissTask = QSDispatch.delay(showTime) { [weak self] in
                self?.dismiss(animated: true)
            }
        }
        
        var parentView: UIView!
        if let view = view {
            parentView = view
        } else {
            guard let window = getKeyWindow() else {
                debugPrint("父视图为空")
                return
            }
            parentView = window
        }
        
        parentView.addSubview(self)
        self.frame = parentView.bounds
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 1.0
        })
    }
    
    /// 消失
    func dismiss(animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            // 立即执行消失吐司任务
            if let block = self.dismissAction {
                // 取消定时任务
                QSDispatch.cancle(self.dismissTask)
                block()
            }

            // 动画时间
            var duration: TimeInterval = 0.0
            if animated {
                duration = 0.3
            }
            UIView.animate(withDuration: duration, animations: { [weak self] in
                self?.alpha = 0.0
            }) { [weak self] _ in
                self?.dismissTask = nil
                self?.dismissAction = nil
                self?.removeFromSuperview()
            }
        }
    }
    
    /// 获取window
    private func getKeyWindow() -> UIView? {
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                guard let scene = windowScene as? UIWindowScene else { continue }
                
                for window in scene.windows {
                    if window.isKeyWindow {
                        return window
                    }
                }
            }
        } else {
            if let keyWindow = UIApplication.shared.keyWindow {
                return keyWindow
            }
        }
        
        return nil
    }
    
    // MARK: - Property
    public var appearanceModel: QSAppearance = QSAppearance.init()
    private var dismissTask: QSTask?
    private var dismissAction: (() -> ())?
    private var titleLabTopConstraint: NSLayoutConstraint!
    
    private var successImage: UIImage {
        if let img = QSImageCache.defaultSuccessImage {
            return img
        }
        
        let imgSize = CGSize.init(width: 40.0, height: 30.0)
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0)
        UIBezierPath.drawSuccessImage(size: imgSize, color: appearanceModel.successImgColor)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        QSImageCache.defaultSuccessImage = img
        return img!
    }
    
    private var errorImage: UIImage {
        if let img = QSImageCache.defaultErrorImage {
            return img
        }
        
        let imgSize = CGSize.init(width: 30.0, height: 30.0)
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0)
        UIBezierPath.drawErrorImage(size: imgSize, color: appearanceModel.errorImgColor)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        QSImageCache.defaultErrorImage = img
        return img!
    }
    
    private var waitImage: UIImage {
        if let img = QSImageCache.defaultWaitImage {
            return img
        }
        
        let imgSize = CGSize.init(width: 45.0, height: 45.0)
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0)
        UIBezierPath.drawWaitImage(size: imgSize, color: appearanceModel.waitImgColor)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        QSImageCache.defaultWaitImage = img
        return img!
    }
    
    // MARK: - Widget
    private lazy var bgView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconImgView: QSImageView = {
        let imgView = QSImageView.init()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var titleLab: UILabel = {
        let lab = UILabel.init()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
}
