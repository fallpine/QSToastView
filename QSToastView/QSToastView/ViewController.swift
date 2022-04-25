//
//  ViewController.swift
//  QSToastView
//
//  Created by Mac on 2022/4/24.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let btn = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 100.0, height: 50.0))
        btn.center = CGPoint.init(x: view.center.x, y: 100.0)
        btn.setTitle("dismiss", for: .normal)
        view.addSubview(btn)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(test), for: .touchUpInside)
        
        let toastView = QSToastTool.share
        toastView.show(toastType: .wait, isMask: false, interval: nil, isIconRotate: true) {
            print("bbb")
        }
    }

    @objc func test() {
        let toastView = QSToastTool.share
        toastView.dismiss()
    }

}

