//
//  LYPresentationController.swift
//  Swift转场动画_简单
//
//  Created by liyang on 16/9/10.
//  Copyright © 2016年 liyang. All rights reserved.
//

import UIKit

class LYPresentationController: UIPresentationController {
    
    
    // MARK:- 设置模板
    private lazy var coverView : UIView = UIView()
    
    // MARK:- 由外界决定弹出
    var presentedFrame : CGRect = CGRectZero
    
    
    // MARK:- 所有被modal出来的控制器都是被添加在一个containerView上的，通过重写该方法来改变modal出控制器的frame
    override func containerViewWillLayoutSubviews() {
        
        // 1、设置弹出view的frame
        presentedView()?.frame = presentedFrame
        
        // 2、设置蒙版
        setupCoverView()
    }
    
}

// MARK: - 设置蒙版
extension LYPresentationController {
    private func setupCoverView() {
        // 1、添加蒙版
        containerView?.insertSubview(coverView, atIndex: 0)
        coverView.frame = containerView!.bounds
        // 2、给蒙版添加一个手势，当点击蒙版的时候，是控制器dismiss
        coverView.backgroundColor = UIColor.lightGrayColor()
        let tapGr = UITapGestureRecognizer(target: self, action: #selector(LYPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGr)
    }
}
// MARK: - 蒙版的事件监听
extension LYPresentationController {
    @objc private func coverViewClick() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

