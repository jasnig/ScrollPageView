//
//  GifAnimator.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class GifAnimator: UIView {
    /// 为不同的state设置不同的图片
    /// 闭包需要返回一个元组: 图片数组和gif动画每一帧的执行时间
    /// 一般需要设置loading状态的图片(必须), 作为加载的gif
    /// 和pullToRefresh状态的图片数组(可选择设置), 作为拖拽时的加载动画
    typealias SetImagesForStateClosure = (refreshState: RefreshViewState) -> (images:[UIImage], duration:Double)?
    /// 为header或者footer的不同的state设置显示的文字
    typealias SetDescriptionClosure = (refreshState: RefreshViewState, refreshType: RefreshViewType) -> String
    /// 设置显示上次刷新时间的显示格式
    typealias SetLastTimeClosure = (date: NSDate) -> String
    
    
    // MARK: - private property
    /// 显示上次刷新时间  可以外界隐藏和自定义字体颜色等
    private(set) lazy var lastTimeLabel: UILabel = {
        let lastTimeLabel = UILabel()
        lastTimeLabel.textColor = UIColor.lightGrayColor()
        lastTimeLabel.backgroundColor = UIColor.clearColor()
        lastTimeLabel.textAlignment = .Center
        lastTimeLabel.font = UIFont.systemFontOfSize(14.0)
        return lastTimeLabel
    }()
    
    /// 显示描述状态的文字  可以外界隐藏和自定义字体颜色等
    private(set) lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.lightGrayColor()
        descriptionLabel.backgroundColor = UIColor.clearColor()
        descriptionLabel.textAlignment = .Center
        descriptionLabel.font = UIFont.systemFontOfSize(14.0)
        return descriptionLabel
    }()
    
    /// gif图片 -> 外界不支持自定义
    private lazy var gifImageView: UIImageView = {
        let gifImageView = UIImageView()
        gifImageView.clipsToBounds = true
        gifImageView.contentMode = .ScaleAspectFit
        return gifImageView
    }()
    /// 缓存图片
    private var imagesDic = [RefreshViewState: (images:[UIImage], duration: Double)]()
    
    private var setupDesctiptionClosure: SetDescriptionClosure?
    private var setupLastTimeClosure: SetLastTimeClosure?
    /// 耗时操作
    private lazy var formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        return formatter
    }()
    /// 耗时操作
    private lazy var calendar: NSCalendar = NSCalendar.currentCalendar()
    private var setupImagesClosure: SetImagesForStateClosure?
    
    // MARK: - public property
    
    /// 是否刷新完成后自动隐藏 默认为false
    /// 这个属性是协议定义的, 当写在class里面可以供外界修改, 如果写在extension里面只能是可读的
    var isAutomaticlyHidden: Bool = false
    /// 这个key如果不指定或者为nil,将使用默认的key那么所有的未指定key的header和footer公用一个刷新时间
    var lastRefreshTimeKey: String? = nil
    /// 图片和字体的间距
    var imageMagin = CGFloat(15.0)
    
    // MARK: - public helper
    /// 为不同的state设置不同的图片
    /// 闭包需要返回一个元组: 图片数组和gif动画每一帧的执行时间
    /// 一般需要设置loading状态的图片(必须), 作为加载的gif
    /// 和pullToRefresh状态的图片数组(可选择设置), 作为拖拽时的加载动画
    func setupImagesForRefreshstate(closure: SetImagesForStateClosure?) {
        guard let imageClosure = closure else { return }
        
        imagesDic[.normal] = imageClosure(refreshState: .normal)
        imagesDic[.pullToRefresh] = imageClosure(refreshState: .pullToRefresh)
        imagesDic[.releaseToFresh] = imageClosure(refreshState: .releaseToFresh)
        imagesDic[.loading] = imageClosure(refreshState: .loading)
        
        for (_, result) in imagesDic {
            if result.images.count != 0 {
                gifImageView.image = result.images.first
                break
            }
        }
    }
    
    
    func setupDescriptionForState(closure: SetDescriptionClosure) {
        setupDesctiptionClosure = closure
    }
    
    func setupLastFreshTime(closure: SetLastTimeClosure) {
        setupLastTimeClosure = closure
    }
    ///
    class func gifAnimatorWithHeight(height: CGFloat) -> GifAnimator {
        let gif = GifAnimator(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height))
        return gif
    }
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gifImageView)
        addSubview(lastTimeLabel)
        addSubview(descriptionLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gifImageView.frame = bounds
        /// setting height and width
        
        if !descriptionLabel.hidden {
            if lastTimeLabel.hidden {
                descriptionLabel.sizeToFit()
                descriptionLabel.center = center
                gifImageView.frame.size.width = descriptionLabel.frame.minX - imageMagin

            }
            else {
                descriptionLabel.sizeToFit()
                lastTimeLabel.sizeToFit()
                descriptionLabel.frame.origin.y = bounds.height/2 - descriptionLabel.bounds.height
                lastTimeLabel.frame.origin.y = descriptionLabel.frame.maxY + 8.0
                descriptionLabel.center.x = center.x
                lastTimeLabel.center.x = center.x

                gifImageView.frame.size.width = min(descriptionLabel.frame.minX, lastTimeLabel.frame.minX) - imageMagin

            }
        }
        
    }
    
}
// MARK: - RefreshViewDelegate
extension GifAnimator: RefreshViewDelegate {
    /// optional 两个可选的实现方法
    /// 允许在控件添加到scrollView之前的准备
    func refreshViewDidPrepare(refreshView: RefreshView, refreshType: RefreshViewType) {
        if refreshType == .header {
            descriptionLabel.text = "继续下拉刷新"
        }
        else {
            descriptionLabel.text = "继续上拉刷新"
            lastTimeLabel.hidden = true
        }
        setupLastTime()
    }
    
    func refreshDidBegin(refreshView: RefreshView, refreshViewType: RefreshViewType) {
        gifImageView.startAnimating()
    }
    
    /// 刷新结束状态, 这个时候应该关闭自定义的(动画)刷新
    func refreshDidEnd(refreshView: RefreshView, refreshViewType: RefreshViewType) {
        gifImageView.stopAnimating()
    }
    
    /// 刷新状态变为新的状态, 这个时候可以自定义设置各个状态对应的属性
    func refreshDidChangeState(refreshView: RefreshView, fromState: RefreshViewState, toState: RefreshViewState, refreshViewType: RefreshViewType) {
        
        setupDescriptionForState(toState, type: refreshViewType)
        switch toState {
        case .loading:
            if gifImageView.isAnimating() {
                gifImageView.stopAnimating()
            }
            guard let result = imagesDic[.loading] , let image = result.images.first else { return }
            if result.images.count == 1 {
                gifImageView.image = image
            }
            else {
                
                gifImageView.animationImages = result.images
                gifImageView.animationDuration = result.duration
            }
            
        case .normal:
            /// 设置时间
            setupLastTime()
            
        default: break
        }
    }
    
    /// 拖拽的进度, 可用于自定义实现拖拽过程中的动画
    func refreshDidChangeProgress(refreshView: RefreshView, progress: CGFloat, refreshViewType: RefreshViewType) {
        if gifImageView.isAnimating() {
            gifImageView.stopAnimating()
        }
        guard let result = imagesDic[.pullToRefresh] where result.images.count != 0 else { return }
        if result.images.count == 1 {
            gifImageView.image = result.images.first
        }
        var index = Int(CGFloat(result.images.count) * progress)
        index = min(index, result.images.count - 1)
        gifImageView.image = result.images[index]
        
    }
}
// MARK: - private helper
extension GifAnimator {
    private func setupLastTime() {
        if lastTimeLabel.hidden { return }
        else {
            guard let lastDate = lastRefreshTime else {
                lastTimeLabel.text = "首次刷新"
                return
            }
            
            if let closure = setupLastTimeClosure {
                lastTimeLabel.text = closure(date:lastDate)
                setNeedsLayout()
            }
            else {
                let lastComponent = calendar.components([.Day, .Year], fromDate: lastDate)
                let currentComponent = calendar.components([.Day, .Year], fromDate: NSDate())
                var todayString = ""
                if lastComponent.day == currentComponent.day {
                    formatter.dateFormat = "HH:mm"
                    todayString = "今天 "
                    
                }
                else if lastComponent.year == currentComponent.year {
                    formatter.dateFormat = "MM-dd HH:mm"
                }
                else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                let timeString = formatter.stringFromDate(lastDate)
                lastTimeLabel.text = "上次刷新时间:" + todayString + timeString
                setNeedsLayout()
            }
        }
    }
    
    private func setupDescriptionForState(state: RefreshViewState, type: RefreshViewType) {
        if descriptionLabel.hidden { return }
        else {
            if let closure = setupDesctiptionClosure {
                descriptionLabel.text = closure(refreshState: state, refreshType: type)
                setNeedsLayout()
                
            }
            else {
                switch state {
                case .normal:
                    descriptionLabel.text = "正常状态"
                case .loading:
                    descriptionLabel.text = "加载数据中..."
                case .pullToRefresh:
                    if type == .header {
                        descriptionLabel.text = "继续下拉刷新"
                    } else {
                        descriptionLabel.text = "继续上拉刷新"
                    }
                case .releaseToFresh:
                    descriptionLabel.text = "松开手刷新"
                    
                }
                setNeedsLayout()
                
            }
        }
    }
    
}
