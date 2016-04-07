//
//  TopScrollView.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class TopScrollView: UIView {
    
    var scrollLineHeight:CGFloat = 2 {
        didSet {
            scrollView.frame.size.height = scrollLineHeight
        }
    }
    
    
    lazy var scrollLine: UIView = UIView()
    
    var titleColor = UIColor.blackColor() {
        didSet {
            for btn in btnsArray {
                btn.setTitleColor(titleColor, forState: .Normal)
            }
        }
    }
    var scrollLineColor = UIColor.blueColor() {
        didSet {
            scrollLine.backgroundColor = scrollLineColor
        }
    }
    var btnsArray: [UIButton] = []
    
    var currentIndex = 0
    var oldIndex = 0

    var titles:[String] = [] {
        didSet {
            var titleX: CGFloat = 0.0
            let titleY: CGFloat = 0.0
            var titleW: CGFloat
            let titleH = bounds.size.height - CGFloat(scrollLineHeight)
            if titles.count <= 4 {
                titleW = bounds.size.width / CGFloat(titles.count)
            } else {
                titleW = 80
            }
            
            scrollLine.frame = CGRect(x: titleX, y: bounds.size.height - CGFloat(scrollLineHeight), width: titleW, height: CGFloat(scrollLineHeight))
            
            for (index, title) in titles.enumerate() {
                titleX = CGFloat(index) * titleW
                
                let frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
                let btn = UIButton(frame: frame)
                btn.tag = index
                btn.setTitle(title, forState: .Normal)
                btn.setTitleColor(titleColor, forState: .Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
                btn.addTarget(self, action: #selector(self.titleBtnOnClick(_:)), forControlEvents: .TouchUpInside)
                btn.titleLabel?.sizeToFit()
                
                if index == 0 {
                    btn.transform = CGAffineTransformMakeScale(1.15, 1.15)
                }
                
//                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btnsArray.append(btn)
                scrollView.addSubview(btn)
                scrollView.contentSize = CGSize(width: CGRectGetMaxX(btn.frame), height: 0)

            }
        }
    }
    
    func titleBtnOnClick(btn: UIButton) {
        currentIndex = btn.tag

        // 可以滚动的时候
        if titles.count > 4 {
            
            if currentIndex < 2 {
                scrollView.setContentOffset(CGPointZero, animated: true)
            } else if currentIndex >= titles.count - 3 {
                let contentOffsetW = scrollView.contentSize.width - bounds.size.width

                scrollView.setContentOffset(CGPoint(x:contentOffsetW, y: 0), animated: true)

            }else {
                let contentOffsetW = btn.frame.origin.x - btn.frame.size.width

                scrollView.setContentOffset(CGPoint(x:contentOffsetW, y: 0), animated: true)

            }

        }
        

        UIView.animateWithDuration(0.5) {[unowned self] in
            self.scrollLine.frame.origin.x = btn.frame.origin.x
            let oldBtn = self.btnsArray[self.oldIndex]
            oldBtn.transform = CGAffineTransformIdentity
            btn.transform = CGAffineTransformMakeScale(1.15, 1.15)

        }
        oldIndex = currentIndex
        
    }
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRectZero)
        
        return collection
    }()
    
    private lazy var scrollView: UIScrollView = {[weak self] in
        let scrollV = UIScrollView()
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.showsVerticalScrollIndicator = false
        scrollV.bounces = true
        scrollV.pagingEnabled = false
        return scrollV
        
    }()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        scrollLine.backgroundColor = scrollLineColor
        scrollView.addSubview(scrollLine)
        addSubview(scrollView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
//        if let lastBtn = btnsArray.last{
//            scrollView.contentSize = CGSize(width: CGRectGetMaxX(lastBtn.frame), height: 0)
//
//        }

    }

}

