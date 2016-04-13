//
//  ScrollPageView.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ScrollPageView: UIView {
    static let cellId = "cellId"
    var segmentStyle = SegmentStyle()
    
    var topView: TopScrollView!
    var contentView: ContentView!
    
    var titlesArray: [String] = []
    /// 所有的子控制器
    var childVcs: [UIViewController] = []
    
    init(frame:CGRect, segmentStyle: SegmentStyle, titles: [String], childVcs:[UIViewController]) {
        self.childVcs = childVcs
        self.titlesArray = titles
        self.segmentStyle = segmentStyle
        assert(childVcs.count == titles.count, "标题的个数必须和子控制器的个数相同")
        super.init(frame: frame)
        // 初始化设置了frame后可以在以后的任何地方直接获取到frame了, 就不必重写layoutsubview()方法在里面设置各个控件的frame
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func commonInit() {
        // 不要添加navigationController包装后的子控制器
        for childVc in childVcs {
            if childVc.isKindOfClass(UINavigationController.self) {
                fatalError("不要添加UINavigationController包装后的子控制器")
            }
        }
        
        topView = TopScrollView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 44), segmentStyle: segmentStyle, titles: titlesArray)
        
        contentView = ContentView(frame: CGRect(x: 0, y: CGRectGetMaxY(topView.frame), width: bounds.size.width, height: bounds.size.height - 44), childVcs: childVcs)
        contentView.delegate = self
        
        addSubview(contentView)
        addSubview(topView)
        // 在这里调用了懒加载的collectionView, 那么之前设置的self.frame将会用于collectionView,如果在layoutsubviews()里面没有相关的处理frame的操作, 那么将导致内容显示不正常
        topView.titleBtnOnClick = {(label: UILabel, index: Int) in
            
            // 不要执行collectionView的scrollView的滚动代理方法
            self.contentView.forbidTouchToAdjustPosition = true
            self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: false)
        }


    }
 
}




extension ScrollPageView: ContentViewDelegate {
    func contentViewDidEndMoveToIndex(currentIndex: Int) {
        topView.adjustTitleOffSetToCurrentIndex(currentIndex)
        topView.adjustUIWithProgress(1.0, oldIndex: currentIndex, currentIndex: currentIndex)
    }
    
    func contentViewMoveToIndex(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        topView.adjustUIWithProgress(progress, oldIndex: fromIndex, currentIndex: toIndex)
    }
}