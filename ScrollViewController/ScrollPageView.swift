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
    
    lazy var contentView: UIView! = UIView(frame: CGRectZero)
    var titlesArray: [String] = []
    /// 所有的子控制器
    var childVcs: [UIViewController] = []
    /// 用来判断是否是点击了title, 点击了就不要调用scrollview的代理来进行相关的计算
    var isClickedTitle = false
    /// 用来记录上一个位置的offSetX, 在滚动过程中实时更新
    var oldOffSetX:CGFloat = 0.0

    lazy var collectionView: UICollectionView = {[weak self] in
        let flowLayout = UICollectionViewFlowLayout()

        let collection = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        if let strongSelf = self {
            flowLayout.itemSize = strongSelf.contentView.bounds.size
            flowLayout.scrollDirection = .Horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            collection.bounces = false
            collection.showsHorizontalScrollIndicator = false
            collection.frame = strongSelf.contentView.bounds
            collection.collectionViewLayout = flowLayout
            collection.pagingEnabled = true
            // 如果不设置代理, 将不会抵用scrollView的delegate方法
            collection.delegate = strongSelf
            collection.dataSource = strongSelf
            collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: ScrollPageView.cellId)
            
        }
        return collection
    }()
    
    
    init(frame:CGRect, segmentStyle: SegmentStyle, titles: [String], childVcs:[UIViewController]) {
        self.childVcs = childVcs
        self.titlesArray = titles
        self.segmentStyle = segmentStyle
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
//        topView.titles = titlesArray
        topView.backgroundColor = UIColor.lightGrayColor()
//        topView.selectedIndex = 2
        
        contentView.frame = CGRect(x: 0, y: CGRectGetMaxY(topView.frame), width: bounds.size.width, height: bounds.size.height - 44)
        collectionView.frame = contentView.bounds
        
        addSubview(contentView)
        addSubview(topView)
        // 在这里调用了懒加载的collectionView, 那么之前设置的self.frame将会用于collectionView,如果在layoutsubviews()里面没有相关的处理frame的操作, 那么将导致内容显示不正常
        contentView.addSubview(collectionView)
        topView.titleBtnOnClick = {(label: UILabel, index: Int) in
            
            // 不要执行collectionView的scrollView的滚动代理方法
            self.isClickedTitle = true
            self.collectionView.setContentOffset(CGPoint(x: self.bounds.size.width * CGFloat(index), y: 0), animated: true)
        }


    }
    
}




extension ScrollPageView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ScrollPageView.cellId, forIndexPath: indexPath)
        // 避免出现重用显示内容出错 ---- 也可以直接给每个cell用不同的reuseIdentifier实现
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let  vc = childVcs[indexPath.row]
        vc.view.frame = contentView.bounds
        cell.contentView.addSubview(vc.view)
        
        return cell
    }
}

extension ScrollPageView: UIScrollViewDelegate {
    
    // 滚动减速完成时再更新title的位置
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
        
        topView.adjustTitleOffSetToCurrentIndex(currentIndex)

        
    }
    
    // 手指开始拖的时候, 记录此时的offSetX, 并且表示不是点击title切换的内容
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        oldOffSetX = scrollView.contentOffset.x
        isClickedTitle = false
    }

    
    // 需要实时更新滚动条的位置
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 如果是点击了title, 就不要计算了, 直接在点击相应的方法里就已经处理了滚动
        if isClickedTitle {
            return
        }
        
        
        let offSetX = scrollView.contentOffset.x
        
        let leftIndex = Int(floor(offSetX / bounds.size.width))
        let rightIndex = leftIndex + 1
        
        if rightIndex >= titlesArray.count {
            return
        }

        // 包含了滚动的方向
        let progress = (offSetX - oldOffSetX) / bounds.size.width
        
        print("\(progress)------\(leftIndex)----\(rightIndex)")
        
        topView.adjustUIWithProgress(progress, leftIndex: leftIndex, rightIndex: rightIndex)
        // 更新为当前offsetx
        oldOffSetX = offSetX

    }
    
}

