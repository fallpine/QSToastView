//
//  QSDispatch.swift
//  QSToastView
//
//  Created by Song on 2022/4/24.
//

import UIKit

typealias QSTask = (_ cancle: Bool) -> Void

class QSDispatch {
    /// 延迟
    ///
    /// - Parameters:
    ///   - time: 延迟时间
    ///   - task: 任务
    class func delay(_ time: TimeInterval, task: @escaping() -> ()) -> QSTask? {
        /// 延迟
        func dispatch_later(block: @escaping()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (() -> Void)? = task
        var result: QSTask?
        
        // 执行task任务
        let delayedClosure: QSTask = { cancle in
            if let internalClosure = closure {
                if !cancle {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        // 调用延迟方法
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        
        return result
    }
    
    /// 取消任务
    /// - Parameter task: 任务
    class func cancle(_ task: QSTask?) {
        task?(true)
    }
}
