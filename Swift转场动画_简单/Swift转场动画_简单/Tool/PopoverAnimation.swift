//
//  PopoverAnimation.swift
//  SwiftWeiBo
//
//  Created by liyang on 16/8/4.
//  Copyright © 2016年 liyang. All rights reserved.
//

import UIKit

class PopoverAnimation: NSObject {
    // MARK:- 对外提供属性
    lazy var isPresent : Bool = false
    
    // MARK:- frame属性
    var popAnimationFrame : CGRect = CGRectZero
    
    // MARK:- 创建一个闭包，传值
    var callBack :((presented : Bool) -> ())?
    
    // MARK:- 自定义构造函数
    // 注意： 如果自定义了一个构造函数，但是没有对默认的构造函数init()进行重写，那么自定义的构造函数将覆盖默认的init()函数
    init(callBack : (presented : Bool) -> ()) {
        self.callBack = callBack
    }
    
}
// MARK: - 转场动画的代理
extension PopoverAnimation: UIViewControllerTransitioningDelegate {
    // 目的：改变弹出view的frame
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let presentation = LYPresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentation.presentedFrame = popAnimationFrame
        
        return presentation
    }
    // 目的：自定义弹出的动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        callBack!(presented : isPresent)
        return self
    }
    // 目的：自定义消失的动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        callBack!(presented : isPresent)
        return self
    }
}

// MARK: - 实现弹出消失的动画代理
extension PopoverAnimation : UIViewControllerAnimatedTransitioning {
    
    // MARK:- 设置动画时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK:- 获取转场的上下文：可以通过转场上下文获取弹出的View和消失的View
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresent ? animateTransitionForPresent(transitionContext) : animateTransitionForDismiss(transitionContext)
    }
    
    // MARK:- 把弹出动画抽一个方法
    func animateTransitionForPresent(transitionContext: UIViewControllerContextTransitioning) {
        // 1、获取弹出的view
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        // 2、将弹出的View添加到containView中
        transitionContext.containerView()?.addSubview(presentedView)
        // 3、执行动画
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0) // 默认这个点在center，我们希望他在上面靠中间的位置
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            // 还原形变属性
            presentedView.transform = CGAffineTransformIdentity
        }) { (_) in
            // 必须告诉转场上下文，我已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
    // MARK:- 把消失动画抽取成一个方法
    func animateTransitionForDismiss(transitionContext: UIViewControllerContextTransitioning) {
        // 1、获取消失的的view
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        // 2、执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            // 还原形变属性
            // iOS对0 处理的并不好，常见的bug就是：我给后面填的参数写0的话，动画直接不执行
            dismissView.transform = CGAffineTransformMakeScale(1.0, 0.01)
        }) { (_) in
            dismissView.removeFromSuperview()
            // 必须告诉转场上下文，我已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}
