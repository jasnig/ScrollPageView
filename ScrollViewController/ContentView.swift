//
//  ContentView.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ContentView: UIView {
    static let cellId = "cellId"
    
    /// 所有的子控制器
    private var childVcs: [UIViewController] = []
    /// 用来判断是否是点击了title, 点击了就不要调用scrollview的代理来进行相关的计算
    private var forbidTouchToAdjustPosition = false
    /// 用来记录开始滚动的offSetX
    private var oldOffSetX:CGFloat = 0.0
    private var oldIndex = 0
    private var currentIndex = 1
    
    weak var delegate: ContentViewDelegate?
    
    lazy var collectionView: UICollectionView = {[weak self] in
        let flowLayout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        if let strongSelf = self {
            flowLayout.itemSize = strongSelf.bounds.size
            flowLayout.scrollDirection = .Horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            collection.bounces = false
            collection.showsHorizontalScrollIndicator = false
            collection.frame = strongSelf.bounds
            collection.collectionViewLayout = flowLayout
            collection.pagingEnabled = true
            // 如果不设置代理, 将不会调用scrollView的delegate方法
            collection.delegate = strongSelf
            collection.dataSource = strongSelf
            collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentView.cellId)
            
        }
        return collection
    }()
    
    
    init(frame:CGRect, childVcs:[UIViewController]) {
        self.childVcs = childVcs
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func commonInit() {
        // 不要添加navigationController包装后的子控制器
        for childVc in childVcs {
            if childVc.isKindOfClass(UINavigationController.self) {
                fatalError("不要添加UINavigationController包装后的子控制器")
            }
        }
        
        collectionView.frame = bounds
        
        // 在这里调用了懒加载的collectionView, 那么之前设置的self.frame将会用于collectionView,如果在layoutsubviews()里面没有相关的处理frame的操作, 那么将导致内容显示不正常
        addSubview(collectionView)
        
    }
    
    func setContentOffSet(offSet: CGPoint , animated: Bool) {
        // 不要执行collectionView的scrollView的滚动代理方法
        self.forbidTouchToAdjustPosition = true
        self.collectionView.setContentOffset(offSet, animated: animated)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds

    }
    
    deinit {
        print("\(self.debugDescription) --- 销毁")
    }
}




extension ContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    final func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    final func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ContentView.cellId, forIndexPath: indexPath)
        // 避免出现重用显示内容出错 ---- 也可以直接给每个cell用不同的reuseIdentifier实现
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let  vc = childVcs[indexPath.row]
        vc.view.frame = bounds
        cell.contentView.addSubview(vc.view)
        
        return cell
    }
 
}

extension ContentView: UIScrollViewDelegate {
    
    /**
     为了解决在滚动或接着点击title更换的时候因为index不同步而增加了下边的两个代理方法的判断
     
     */
    // 滚动减速完成时再更新title的位置
    //
    final func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
        
        delegate?.contentViewDidEndMoveToIndex(currentIndex)
        // 保证如果滚动没有到下一页就返回了上一页, 那么在didScroll的代理里面执行之后, currentIndex和oldIndex不对
        // 通过这种方式再次正确设置 index
        
    }
    
    
    // 手指开始拖的时候, 记录此时的offSetX, 并且表示不是点击title切换的内容
    final func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        /// 用来判断方向
        oldOffSetX = scrollView.contentOffset.x
        
        forbidTouchToAdjustPosition = false
        delegate?.contentViewDidBeginMove()
    }
    
    // 需要实时更新滚动的进度和移动的方向及下标 以便于外部使用
    final func scrollViewDidScroll(scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        
        // 如果是点击了title, 就不要计算了, 直接在点击相应的方法里就已经处理了滚动
        if forbidTouchToAdjustPosition {
            return
        }
        
        let temp = offSetX / bounds.size.width
        var progress = temp - floor(temp)
        
        if offSetX - oldOffSetX >= 0 {// 手指左滑, 滑块右移
            if progress == 0.0 {// 滚动开始和滚动完成的时候不要继续
                return
            }
            oldIndex = Int(floor(offSetX / bounds.size.width))
            currentIndex = oldIndex + 1
            if currentIndex >= childVcs.count {
                // 不要越界, 越界后直接设置currentIndex为数组最后下标
                // 同时为了避免在最后一页时滚动没有完成返回了原来那一页,导致index错误,就直接返回了, 在完成的代理方法里面重新设置了index
                currentIndex = childVcs.count - 1
                return
            }
            
        } else {// 手指右滑, 滑块左移
            currentIndex = Int(floor(offSetX / bounds.size.width))
            oldIndex = currentIndex + 1
            if oldIndex >= childVcs.count {
                oldIndex = childVcs.count - 1
                return
            }
            progress = 1.0 - progress
            
        }
        
        //        print("\(progress)------\(oldIndex)----\(currentIndex)")
        
        delegate?.contentViewMoveToIndex(oldIndex, toIndex: currentIndex, progress: progress)
        
        
        
    }

    
}


protocol ContentViewDelegate: class {
    /// 有默认实现, 不推荐重写
    func contentViewMoveToIndex(fromIndex: Int, toIndex: Int, progress: CGFloat)
    /// 有默认实现, 不推荐重写
    func contentViewDidEndMoveToIndex(currentIndex: Int)
    /// 无默认操作, 推荐重写
    func contentViewDidBeginMove()
    /// 必须提供的属性
    var segmentView: ScrollSegmentView { get }
}

// 由于每个遵守这个协议的都需要执行些相同的操作, 所以直接使用协议扩展统一完成,协议遵守者只需要提供segmentView即可
extension ContentViewDelegate {
    
    // 默认什么都不做
    func contentViewDidBeginMove() {
        
    }
    
    // 内容每次滚动完成时调用, 确定title和其他的控件的位置
    func contentViewDidEndMoveToIndex(currentIndex: Int) {
        segmentView.adjustTitleOffSetToCurrentIndex(currentIndex)
        segmentView.adjustUIWithProgress(1.0, oldIndex: currentIndex, currentIndex: currentIndex)
    }
    
    // 内容正在滚动的时候,同步滚动滑块的控件
    func contentViewMoveToIndex(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        segmentView.adjustUIWithProgress(progress, oldIndex: fromIndex, currentIndex: toIndex)
    }
}