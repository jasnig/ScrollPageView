//
//  NormalAnimator.swift
//  PullToRefresh
//
//  Created by ZeroJ on 16/7/20.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

public class NormalAnimator: UIView {
    /// 设置imageView
    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var indicatorView: UIActivityIndicatorView!
    /// 设置state描述
    @IBOutlet private(set) weak var descroptionLabel: UILabel!
    /// 上次刷新时间label footer 默认为hidden, 可设置hidden=false开启
    @IBOutlet private(set) weak var lastTimelabel: UILabel!

    
    public typealias SetDescriptionClosure = (refreshState: RefreshViewState, refreshType: RefreshViewType) -> String
    public typealias SetLastTimeClosure = (date: NSDate) -> String
    
    
    /// 是否刷新完成后自动隐藏 默认为false
    /// 这个属性是协议定义的, 当写在class里面可以供外界修改, 如果写在extension里面只能是可读的
    public var isAutomaticlyHidden: Bool = false
    /// 这个key如果不指定或者为nil,将使用默认的key那么所有的未指定key的header和footer公用一个刷新时间
    public var lastRefreshTimeKey: String? = nil
    
    private var setupDesctiptionClosure: SetDescriptionClosure?
    private var setupLastTimeClosure: SetLastTimeClosure?
    /// 耗时
    private lazy var formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        return formatter
    }()
    /// 耗时
    private lazy var calendar: NSCalendar = NSCalendar.currentCalendar()
    
    public class func normalAnimator() -> NormalAnimator {
        let normalAnimator = NSBundle.mainBundle().loadNibNamed(String(NormalAnimator), owner: nil, options: nil).first as! NormalAnimator

        return normalAnimator
    }
    
    
    public func setupDescriptionForState(closure: SetDescriptionClosure) {
        setupDesctiptionClosure = closure
    }
    
    public func setupLastFreshTime(closure: SetLastTimeClosure) {
        setupLastTimeClosure = closure
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.hidden = true
        indicatorView.hidesWhenStopped = true
    }
    
    //    public override func layoutSubviews() {
    //        super.layoutSubviews()
    //        print("layout--------------------------------------------")
    //    }
}

extension NormalAnimator: RefreshViewDelegate {
    
    public func refreshViewDidPrepare(refreshView: RefreshView, refreshType: RefreshViewType) {
        if refreshType == .header {
        } else {
            lastTimelabel.hidden = true
            rotateArrowToUpAnimated(false)
        }
        setupLastTime()
        
    }
    
    public func refreshDidBegin(refreshView: RefreshView, refreshViewType: RefreshViewType) {
        indicatorView.hidden = false
        indicatorView.startAnimating()
    }
    public func refreshDidEnd(refreshView: RefreshView, refreshViewType: RefreshViewType) {
        indicatorView.stopAnimating()
    }
    public func refreshDidChangeProgress(refreshView: RefreshView, progress: CGFloat, refreshViewType: RefreshViewType) {
        //        print(progress)
        
    }
    
    public func refreshDidChangeState(refreshView: RefreshView, fromState: RefreshViewState, toState: RefreshViewState, refreshViewType: RefreshViewType) {
        print(toState)
        
        setupDescriptionForState(toState, type: refreshViewType)
        switch toState {
        case .loading:
            imageView.hidden = true
        case .normal:
            
            setupLastTime()
            imageView.hidden = false
            ///恢复
            if refreshViewType == .header {
                rotateArrowToDownAnimated(false)
                
            } else {
                rotateArrowToUpAnimated(false)
            }
            
        case .pullToRefresh:
            if refreshViewType == .header {
                
                if fromState == .releaseToFresh {
                    rotateArrowToDownAnimated(true)
                }
                
            } else {
                
                if fromState == .releaseToFresh {
                    rotateArrowToUpAnimated(true)
                }
            }
            imageView.hidden = false
            
        case .releaseToFresh:
            
            imageView.hidden = false
            if refreshViewType == .header {
                rotateArrowToUpAnimated(true)
            } else {
                rotateArrowToDownAnimated(true)
            }
        }
    }
    
    private func rotateArrowToDownAnimated(animated: Bool) {
        let time = animated ? 0.2 : 0.0
        UIView.animateWithDuration(time, animations: {
            self.imageView.transform = CGAffineTransformIdentity
            
        })
    }
    
    private func rotateArrowToUpAnimated(animated: Bool) {
        let time = animated ? 0.2 : 0.0
        UIView.animateWithDuration(time, animations: {
            self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            
        })
    }
    
    private func setupLastTime() {
        if lastTimelabel.hidden {
            lastTimelabel.text = ""
        } else {
            guard let lastDate = lastRefreshTime else {
                lastTimelabel.text = "首次刷新"
                return
            }
            
            if let closure = setupLastTimeClosure {
                lastTimelabel.text = closure(date:lastDate)
            } else {
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
                lastTimelabel.text = "上次刷新时间:" + todayString + timeString
            }
        }
    }
    
    private func setupDescriptionForState(state: RefreshViewState, type: RefreshViewType) {
        if descroptionLabel.hidden {
            descroptionLabel.text = ""
        } else {
            if let closure = setupDesctiptionClosure {
                descroptionLabel.text = closure(refreshState: state, refreshType: type)
            } else {
                switch state {
                case .normal:
                    descroptionLabel.text = "正常状态"
                case .loading:
                    descroptionLabel.text = "加载数据中..."
                case .pullToRefresh:
                    if type == .header {
                        descroptionLabel.text = "继续下拉刷新"
                    } else {
                        descroptionLabel.text = "继续上拉刷新"
                    }
                case .releaseToFresh:
                    descroptionLabel.text = "松开手刷新"
                    
                }
            }
        }
    }
    
}
