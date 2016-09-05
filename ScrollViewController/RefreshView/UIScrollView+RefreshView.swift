//
//  UIScrollView+RefreshView.swift
//  PullToRefresh
//
//  Created by ZeroJ on 16/7/20.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

private var ZJHeaderKey: UInt8 = 0
private var ZJFooterKey: UInt8 = 0

extension UIScrollView {
    public typealias RefreshHandler = () -> Void
    
    private var zj_refreshHeader: RefreshView? {
        set {
            objc_setAssociatedObject(self, &ZJHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &ZJHeaderKey) as? RefreshView
        }
    }
    private var zj_refreshFooter: RefreshView? {
        set {
            objc_setAssociatedObject(self, &ZJFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &ZJFooterKey) as? RefreshView
        }
    }
    
    ///
    public func zj_addRefreshHeader<Animator where Animator: UIView, Animator: RefreshViewDelegate>(headerAnimator: Animator, refreshHandler: RefreshHandler ) {
        if let header = zj_refreshHeader {
            header.removeFromSuperview()
        }
        ///
        let frame = CGRect(x: 0.0, y: -headerAnimator.bounds.height, width: bounds.width, height: headerAnimator.bounds.height)
        zj_refreshHeader = RefreshView(frame: frame, refreshType: .header, refreshAnimator: headerAnimator, refreshHandler: refreshHandler)
        addSubview(zj_refreshHeader!)
        
    }
    ///
    public func zj_addRefreshFooter<Animator where Animator: UIView, Animator: RefreshViewDelegate>(footerAnimator: Animator, refreshHandler: RefreshHandler ) {
        if let footer = zj_refreshFooter {
            footer.removeFromSuperview()
        }
        /// this may not the final position
        let frame = CGRect(x: 0.0, y: contentSize.height, width: bounds.width, height: footerAnimator.bounds.height)
        zj_refreshFooter = RefreshView(frame: frame, refreshType: .footer,  refreshAnimator: footerAnimator, refreshHandler: refreshHandler)
        addSubview(zj_refreshFooter!)
    }
    /// 开启header刷新
    public func zj_startHeaderAnimation() {
        zj_refreshHeader?.canBegin = true
    }
    /// 结束header刷新
    public func zj_stopHeaderAnimation() {
        zj_refreshHeader?.canBegin = false
    }
    /// 开启footer刷新
    public func zj_startFooterAnimation() {
        zj_refreshFooter?.canBegin = true
    }
    /// 结束footer刷新
    public func zj_stopFooterAnimation() {
        zj_refreshFooter?.canBegin = false
    }
    
}