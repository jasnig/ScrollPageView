//
//  TopScrollView.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


struct SegmentStyle {
    /// 是否显示下划线
    var showCover = true
    /// 是否显示遮盖
    var showLine = true
    /// 是否缩放文字
    var scaleTitle = true
    /// 下面的滚动条的高度
    var scrollLineHeight: CGFloat = 2
    /// 文字颜色
    var titleColor = UIColor.blueColor()
    /// 下面的滚动条的颜色
    var scrollLineColor = UIColor.brownColor()
    /// 遮盖的背景颜色
    var coverBackgroundColor = UIColor.lightTextColor()
    /// 文字间的间隔
    var titleMargin: CGFloat = 15
    /// 文字 字体
    var titleFont = UIFont.systemFontOfSize(14.0)
    /// 遮盖圆角
    var coverCornerRadius = 5.0
    
    
    
}


class TopScrollView: UIView {
    
    
    /**
     之前使用在titles的didSet里面添加label和计算label的文字宽度,
     然后在layoutSubview()里面设置各个label和cover scrollline的frame,
     但是总是导致,默认缩放的label的文字显示不完整,
     修改未在初始化方法里面来设置frame并且设置transform后就可以正常显示了
     
     */
    
    /// 所有的title设置
    var segmentStyle: SegmentStyle
    
    /// 点击响应的blosure
    var titleBtnOnClick:((label: UILabel, index: Int) -> Void)?
    
    /// self.bounds.size.width
    private var currentWidth: CGFloat = 0
    /// 遮盖x和文字x的间隙
    private var xGap = 3
    /// 遮盖宽度比文字宽度多的部分
    private var wGap: Int {
        return 2 * xGap
    }

    /// 缓存标题labels
    private var labelsArray: [UILabel] = []
    /// 记录当前选中的下标
    private var currentIndex = 0
    /// 记录上一个下标
    private var oldIndex = 0
    /// 用来缓存所有标题的宽度, 达到根据文字的字数和font自适应控件的宽度
    private var titlesWidthArray: [CGFloat] = []
    /// 所有的标题
    var titles:[String]
    
    private lazy var scrollView: UIScrollView = {[weak self] in
        let scrollV = UIScrollView()
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.bounces = true
        scrollV.pagingEnabled = false
        return scrollV
        
    }()
    
//    var selectedIndex = 0 {
//        didSet {
//            for (index, label) in labelsArray.enumerate() {
//                if index == selectedIndex {
//                    // 设置transform 需要在控件将要显示或者已经显示在屏幕上的时候设置, 否则字体等显示不正常
//                    label.transform = CGAffineTransformMakeScale(1.3, 1.3)
//                }
//            }
//        }
//    }

    lazy var scrollLine: UIView? = {[unowned self] in
        let line = UIView()
        return self.segmentStyle.showLine ? line : nil
    }()

    lazy var coverLayer: UIView? = {[unowned self] in
        let cover = UIView()
        cover.layer.cornerRadius = CGFloat(self.segmentStyle.coverCornerRadius)
        // 这里只有一个cover 需要设置圆角, 故不用考虑离屏渲染的消耗, 直接设置 masksToBounds 来设置圆角
        cover.layer.masksToBounds = true
//        cover.backgroundColor = self.segmentStyle.coverBackgroundColor
        
        return self.segmentStyle.showCover ? cover : nil
    
    }()
    
    init(frame: CGRect, segmentStyle: SegmentStyle, titles: [String]) {
        self.segmentStyle = segmentStyle
        self.titles = titles
        super.init(frame: frame)
        
        // 设置了frame之后可以直接设置其他的控件的frame了, 不需要在layoutsubView()里面设置
        setupTitles()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitles() {
        for (index, title) in titles.enumerate() {
            
            let label = CustomLabel(frame: CGRectZero)
            label.tag = index
            label.text = title
            label.textColor = segmentStyle.titleColor
            label.font = segmentStyle.titleFont
            label.textAlignment = .Center
            label.userInteractionEnabled = true
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelOnClick(_:)))
            label.addGestureRecognizer(tapGes)
            
            let size = (title as NSString).boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), 0.0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
            
            titlesWidthArray.append(size.width)
            labelsArray.append(label)
            scrollView.addSubview(label)
        }
    }
    
    func setupUI() {
        currentWidth = bounds.size.width
        scrollView.frame = bounds
        addSubview(scrollView)
        // 先设置label的位置
        setUpLabelsPosition()
        // 再设置滚动条和cover的位置
        setupScrollLineAndCover()
        
        if let lastBtn = labelsArray.last {
            scrollView.contentSize = CGSize(width: CGRectGetMaxX(lastBtn.frame) + segmentStyle.titleMargin, height: 0)
            
        }
    }
    // 先设置label的位置
    private func setupScrollLineAndCover() {
        if let line = scrollLine {
            line.backgroundColor = segmentStyle.scrollLineColor
            scrollView.addSubview(line)
            
        }
        if let cover = coverLayer {
            cover.backgroundColor = segmentStyle.coverBackgroundColor
            scrollView.insertSubview(cover, atIndex: 0)
            
        }
        let coverX = labelsArray[0].frame.origin.x
        let coverW = labelsArray[0].frame.size.width
        let coverH: CGFloat = 28
        let coverY = (bounds.size.height - coverH) / 2
        
        scrollLine?.frame = CGRect(x: coverX, y: bounds.size.height - segmentStyle.scrollLineHeight, width: coverW, height: segmentStyle.scrollLineHeight)
        
        // 这里x-xGap width+wGap 是为了让遮盖的左右边缘和文字有一定的距离
        coverLayer?.frame = CGRect(x: coverX - CGFloat(xGap), y: coverY, width: coverW + CGFloat(wGap), height: coverH)
        

    }
    // 再设置滚动条和cover的位置
    private func setUpLabelsPosition() {
        var titleX: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleH = bounds.size.height - segmentStyle.scrollLineHeight
        
        var textWidthSum: CGFloat = segmentStyle.titleMargin
        for textWidth in titlesWidthArray {
            textWidthSum = textWidthSum + textWidth + segmentStyle.titleMargin
        }
        
        
        if textWidthSum < currentWidth {//小余屏幕宽度,平分宽度
            titleW = currentWidth / CGFloat(titles.count)
            
            for (index, label) in labelsArray.enumerate() {
                
                titleX = CGFloat(index) * titleW
                
                label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
                
            }
            
        } else {
            
            for (index, label) in labelsArray.enumerate() {
                titleW = titlesWidthArray[index]
                
                titleX = segmentStyle.titleMargin
                if index != 0 {
                    let lastLabel = labelsArray[index - 1]
                    titleX = CGRectGetMaxX(lastLabel.frame) + segmentStyle.titleMargin
                }
                label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
                
                if !segmentStyle.scaleTitle {
                    return
                }
                // 缩放, 设置初始的label的transform
                // FIXME: 这里目前只是默认设置第一个label为初始的label, 修改为可指定为任意的...
                if index == 0 {
                    let firstLabel = label as! CustomLabel
                    // 如果是在layoutSubview()里面设置使用的transform后label的frame不会改变
                    firstLabel.transform = CGAffineTransformMakeScale(1.3, 1.3)
                    firstLabel.currentTransformSx = 1.3
                    
                }
            }
            
        }
        
    }

    // 点击时直接实现变化
    func titleLabelOnClick(tapGes: UITapGestureRecognizer) {
        guard let currentLabel = tapGes.view as? CustomLabel else { return }
        currentIndex = currentLabel.tag
        
        adjustTitleOffSetToCurrentIndex(currentIndex)
        
        UIView.animateWithDuration(0.5) {[unowned self] in
            
            if self.segmentStyle.scaleTitle {
                let oldLabel = self.labelsArray[self.oldIndex] as! CustomLabel
                oldLabel.transform = CGAffineTransformIdentity
                
                currentLabel.transform = CGAffineTransformMakeScale(1.3, 1.3)
                currentLabel.currentTransformSx = 1.3
                oldLabel.currentTransformSx = 1.0
            }
            
            self.scrollLine?.frame.origin.x = currentLabel.frame.origin.x
            // 注意, 通过bounds 获取到的width 是没有进行transform之前的 所以使用frame
            self.scrollLine?.frame.size.width = currentLabel.frame.size.width
            
            self.coverLayer?.frame.origin.x = currentLabel.frame.origin.x - CGFloat(self.xGap)
            self.coverLayer?.frame.size.width = currentLabel.frame.size.width + CGFloat(self.wGap)
            

            
        }
        oldIndex = currentIndex
        
        titleBtnOnClick?(label: currentLabel, index: currentIndex)
    }
    
    // 手动滚动时需要提供动画效果
    func adjustUIWithProgress(progress: CGFloat,  leftIndex: Int, rightIndex: Int) {
        oldIndex = progress >= 0 ? rightIndex : leftIndex
        currentIndex = progress >= 0 ? leftIndex : rightIndex
        
        let leftLabel = labelsArray[leftIndex] as! CustomLabel
        let rightLabel = labelsArray[rightIndex] as! CustomLabel
        
        // 这里使用center.x显示不正确
        let xDistance = rightLabel.frame.origin.x - leftLabel.frame.origin.x
        
        // 注意, 通过bounds 获取到的width 是没有进行transform之前的 所以使用frame, 避免因为使用了缩放效果引起显示位置不正确

        let wDistance = rightLabel.frame.size.width - leftLabel.frame.size.width

        let deltaX = xDistance * progress
        let deltaW = wDistance * progress
        
        
        // 设置滚动条位置
        scrollLine?.frame.origin.x += deltaX
        scrollLine?.frame.size.width += deltaW
        
        // 设置 cover位置
        coverLayer?.frame.size.width += deltaW
        coverLayer?.frame.origin.x += deltaX
        
        
        
        if !segmentStyle.scaleTitle {
            return
        }
        // 注意左右间的比例是相关连的, 加减相同
        leftLabel.currentTransformSx -= 0.3 * progress
        rightLabel.currentTransformSx += 0.3 * progress
        
        leftLabel.transform = CGAffineTransformMakeScale(leftLabel.currentTransformSx, leftLabel.currentTransformSx)
        rightLabel.transform = CGAffineTransformMakeScale(rightLabel.currentTransformSx, rightLabel.currentTransformSx)
        
//        print("\(leftLabel.currentTransformSx)-----\(rightLabel.currentTransformSx)")
        
        // 由于使用了缩放的时候,label的frame都在变化, 所以根据以上的方法设置的 coverLayer, scrollLine的frame和width就回显示不正常, 所以在将要缩放完成的时候(0.02 为大概的范围), 重新设置 --- 影响性能!!!
        if fabs(leftLabel.currentTransformSx - 1.0) <= 0.02 {
            
            // 设置滚动条位置
            scrollLine?.frame.origin.x = rightLabel.frame.origin.x - CGFloat(xGap)
            scrollLine?.frame.size.width = rightLabel.frame.size.width + CGFloat(wGap)
            
            // 设置 cover位置
            coverLayer?.frame.size.width = rightLabel.frame.size.width + CGFloat(wGap)
            coverLayer?.frame.origin.x = rightLabel.frame.origin.x - CGFloat(xGap)
            
        }
        if fabs(rightLabel.currentTransformSx - 1.0) <= 0.02 {
            
            // 设置滚动条位置
            scrollLine?.frame.origin.x = leftLabel.frame.origin.x - CGFloat(xGap)
            scrollLine?.frame.size.width = leftLabel.frame.size.width + CGFloat(wGap)
            
            // 设置 cover位置
            coverLayer?.frame.size.width = leftLabel.frame.size.width + CGFloat(wGap)
            coverLayer?.frame.origin.x = leftLabel.frame.origin.x - CGFloat(xGap)
            
        }


    }

    func adjustTitleOffSetToCurrentIndex(currentIndex: Int) {
        let currentLabel = labelsArray[currentIndex]

        var offSetX = currentLabel.center.x - currentWidth / 2
        if offSetX < 0 {
            offSetX = 0
        }
        
        var maxOffSetX = scrollView.contentSize.width - currentWidth + segmentStyle.titleMargin
        
        // 可以滚动的区域小余屏幕宽度
        if maxOffSetX < 0 {
            maxOffSetX = 0
        }
        
        if offSetX > maxOffSetX {
            offSetX = maxOffSetX
        }
        
        scrollView.setContentOffset(CGPoint(x:offSetX, y: 0), animated: true)
    }

}


class CustomLabel: UILabel {
    /// 用来记录当前label的缩放比例
    var currentTransformSx:CGFloat = 1.0
}


