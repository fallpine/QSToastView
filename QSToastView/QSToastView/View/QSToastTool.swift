//
//  QSToastTool.swift
//  QSToastView
//
//  Created by Mac on 2022/4/25.
//

import UIKit

public class QSToastTool {
    var appearance: QSAppearance?
    
    /// 设置样式
    /// - Parameter appearance: 样式
    public func setAppearance(_ appearance: QSAppearance) {
        self.appearance = appearance
    }
    
    // MARK: - Func
    /// 显示
    /// - Parameters:
    ///   - view: 父视图
    ///   - toastType: 吐司类型
    ///   - interval: 显示时间，nil表示一直显示
    ///   - icon: 图标，如果是gif图，需要把后缀名带上
    ///   - isIconRotate: 图标是否旋转
    ///   - title: 标题
    ///   - dismiss: 隐藏回调
    public func show(in view: UIView? = nil, toastType: QSToastType, interval: TimeInterval?, icon: String? = nil, isIconRotate: Bool = false, title: String = "", dismiss: (() -> ())? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.showlock.lock()
            
            guard let `self` = self else { self?.showlock.unlock(); return }
            
            if let toast = self.toastArray.last {
                UIView.animate(withDuration: 0.3) {
                    toast.alpha = 0.0
                }
            }
            
            let toastView = QSToastView.init(appearance: self.appearance ?? QSAppearance.init())
            toastView.tag = 66 + self.toastArray.count
            toastView.showToast(in: view, toastType: toastType, interval: interval, icon: icon, isIconRotate: isIconRotate, title: title) { [weak self] in
                if let action = dismiss {
                    action()
                }
                
                if let index = self?.toastArray.firstIndex(where: { view in
                    return view.tag == toastView.tag
                }) {
                    self?.toastArray.remove(at: index)
                }
                
                if let toast = self?.toastArray.last {
                    UIView.animate(withDuration: 0.3) {
                        toast.alpha = 1.0
                    }
                }
            }
            self.toastArray.append(toastView)
            self.showlock.unlock()
        }
    }
    
    /// 隐藏
    public func dismiss() {
        dismisslock.lock()
        guard !toastArray.isEmpty else { dismisslock.unlock(); return }
        
        let toast = toastArray.removeFirst()
        toast.dismiss(animated: true)
        dismisslock.unlock()
    }
    
    // MARK: - Property
    public static let share = QSToastTool()
    private var toastArray: [QSToastView] = []
    private let showlock = NSLock.init()
    private let dismisslock = NSLock.init()
}
