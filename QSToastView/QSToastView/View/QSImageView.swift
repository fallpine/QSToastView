//
//  QSImageView.swift
//  QSToastView
//
//  Created by Mac on 2022/4/25.
//

import UIKit
import ImageIO
import QuartzCore
import CommonCrypto

class QSImageView: UIImageView {
    private var gifUrl: URL?
    private var gifMaxSize: CGSize?
    private var totalTime: Double = 0.0
    private var imageArray: Array<CGImage> = []
    private var timeArray: Array<NSNumber> = []
    
    /// 加载图片
    /// - Parameters:
    ///   - name: 图片名称
    ///   - sizeBlock: gif图大小
    func loadImage(_ name: String, gifSize: @escaping ((CGSize) -> ())) {
        if name.hasSuffix(".gif") {
            if name.lowercased().hasPrefix("http://") || name.lowercased().hasPrefix("https://") {
                loadNetGif(with: name, gifSize: gifSize)
            } else {
                loadLocalGif(with: name)
                if let size = gifMaxSize {
                    gifSize(size)
                }
            }
        } else {
            self.image = UIImage.init(named: name)
        }
    }
    
    /// 加载本地gif图片
    private func loadLocalGif(with name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType:"") else { return }
        
        gifUrl = URL.init(fileURLWithPath: path)
        getImagesAndSize()
        showGif()
    }
    
    /// 加载网络Gif
    /// - Parameter url: gif的url地址
    private func loadNetGif(with name: String, gifSize: @escaping ((CGSize) -> ())) {
        guard let url = URL.init(string: name) else { return }
        
        let fileName = md5String(string: url.absoluteString)
        let filePath = NSHomeDirectory() + "/Library/Caches/" + fileName + ".gif"
        if FileManager.default.fileExists(atPath: filePath) {
            gifUrl = URL.init(fileURLWithPath: filePath)
            getImagesAndSize()
            showGif()
            
            // 设置控件大小
            if let size = gifMaxSize {
                gifSize(size)
            }
        } else {
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                DispatchQueue.main.async { [weak self] in
                    let path = URL.init(fileURLWithPath: filePath)
                    do{
                        try data?.write(to: path as URL)
                        self?.gifUrl = URL.init(fileURLWithPath: filePath)
                        self?.getImagesAndSize()
                        self?.showGif()
                        
                        // 设置控件大小
                        if let size = self?.gifMaxSize {
                            gifSize(size)
                        }
                    }catch{
                        debugPrint("写入失败")
                    }
                }
            })
            task.resume()
        }
    }
    
    /// 获取图片数组和大小
    private func getImagesAndSize() {
        guard let gifUrl = self.gifUrl else { return }
        
        var width: Double = 0.0
        var height: Double = 0.0
        
        let url: CFURL = gifUrl as CFURL
        guard let gifSource = CGImageSourceCreateWithURL(url, nil) else { return }
        let imageCount = CGImageSourceGetCount(gifSource)
        for i in 0 ..< imageCount {
            if let imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, nil) {
                imageArray.append(imageRef)
                
                let gifSourceDict = CGImageSourceCopyPropertiesAtIndex(gifSource, i, nil) as NSDictionary?
                if let sourceDict = gifSourceDict {
                    // 获取宽高
                    if let imageWidth = sourceDict[String(kCGImagePropertyPixelWidth)] as? NSNumber,
                       let imageHeight = sourceDict[String(kCGImagePropertyPixelHeight)] as? NSNumber {
                        width = max(width, imageWidth.doubleValue)
                        height = max(height, imageHeight.doubleValue)
                        gifMaxSize = CGSize.init(width: width, height: height)
                    }
                    
                    // 图片展示时间
                    if let gifDict = sourceDict[String(kCGImagePropertyGIFDictionary)] as? NSDictionary {
                        if let time = gifDict[String(kCGImagePropertyGIFDelayTime)] as? NSNumber {
                            timeArray.append(time)
                            totalTime += time.doubleValue
                        }
                    }
                }
            }
        }
    }
    
    /// 展示gif
    private func showGif() {
        let animation = CAKeyframeAnimation(keyPath: "contents")
        var currentTime: Double = 0.0
        var timeKeys: Array<NSNumber> = []
        
        for time in timeArray {
            timeKeys.append(NSNumber(value: currentTime / totalTime))
            currentTime += time.doubleValue
        }
        animation.keyTimes = timeKeys
        animation.values = imageArray
        animation.duration = TimeInterval(totalTime)
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "gifView")
    }
    
    /// MD5加密
    private func md5String(string: String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        free(result)
        
        return String(format: hash as String)
    }
}
