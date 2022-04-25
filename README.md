# QSToastView
### 吐司提示框
使用方法：直接用Pod导入，pod 'QSToastView'
QSToastView导入项目之后，可直接使用QSToastTool来进行吐司的展示和隐藏
QSToastTool本身是一个单例
```
// 创建单例
let tool = QSToastTool.share
```
```
/// 显示
/// - Parameters:
///   - view: 父视图
///   - toastType: 吐司类型
///   - isMask: 是否有遮罩
///   - interval: 显示时间，nil表示一直显示
///   - icon: 图标，如果是gif图，需要把后缀名带上
///   - isIconRotate: 图标是否旋转
///   - title: 标题
///   - dismiss: 隐藏回调
public func show(in view: UIView? = nil, toastType: QSToastType, isMask: Bool = true, interval: TimeInterval?, icon: String? = nil, isIconRotate: Bool = false, title: String = "", dismiss: (() -> ())?)

/// 隐藏
public func dismiss()
```
```
// 吐司类型
public enum QSToastType {
    case success    // 成功
    case error      // 失败
    case wait       // 等待
    case text       // 纯文本
}
```
