//
//  ViewController.swift
//  Swift转场动画_简单
//
//  Created by liyang on 16/9/10.
//  Copyright © 2016年 liyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- 懒加载初始化pop模型代理
    private lazy var popoverAnimation : PopoverAnimation = PopoverAnimation { (presented) in
        // 回调结果
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn : UIButton = UIButton(type: .Custom)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        btn.setTitle("点击", forState: .Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        btn.addTarget(self, action: #selector(ViewController.jumpToOtherVc(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(btn)
        
    }
}


extension ViewController {
    @objc private func jumpToOtherVc (sender : UIButton) {
        
        let vc = OtherViewController()
        // 3、设置控制器的modal样式
        vc.modalPresentationStyle = .Custom
        // 4、设置转场的代理
        vc.transitioningDelegate = popoverAnimation
        // 5、设置presentedView的frame
        popoverAnimation.popAnimationFrame = CGRectMake(100, 56, 180, 250)
        // 6、弹出控制器
        presentViewController(vc, animated: true, completion: nil)
    }
}
