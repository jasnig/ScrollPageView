//
//  Vc8Controller.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/21.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//
import UIKit

/// 这些常量请根据项目需要修改
let segmentViewHeight: CGFloat = 44.0
let naviBarHeight: CGFloat = 64.0
let headViewHeight: CGFloat = 200.0
let defaultOffSetY: CGFloat = segmentViewHeight + naviBarHeight + headViewHeight


class Vc8Controller: UIViewController {
    
    
    // 懒加载 topView
    lazy var topView: ScrollSegmentView! = {[unowned self] in
        
        var style = SegmentStyle()
        
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 遮盖
        style.showCover = true
        // 遮盖颜色
        style.coverBackgroundColor = UIColor.whiteColor()
        
        // title正常状态颜色 使用RGB空间值
        style.normalTitleColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        // title选中状态颜色 使用RGB空间值
        style.selectedTitleColor = UIColor(red: 235.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        let titles = ["国内头条", "国际要闻", "趣事", "囧图", "明星八卦", "爱车", "国防要事", "科技频道", "手机专页", "风景图", "段子"]
        
        let topView = ScrollSegmentView(frame: CGRect(x: CGFloat(0.0), y: naviBarHeight + headViewHeight, width: self.view.bounds.size.width, height: segmentViewHeight), segmentStyle: style, titles: titles)
        
        topView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: false)
            
        }
        topView.backgroundColor = UIColor.lightGrayColor()
        return topView
        
        }()
    
    // 懒加载 contentView
    lazy var contentView: ContentView! = {[unowned self] in
        let contentView = ContentView(frame: self.view.bounds, childVcs: self.setChildVcs(), parentViewController: self)
        contentView.delegate = self // 必须实现代理方法
        return contentView
        }()
    
    // 懒加载 heacView
    lazy var headView: UIImageView! =  {
        let headView = UIImageView(frame: CGRect(x: 0.0, y: naviBarHeight, width: self.view.bounds.size.width, height: headViewHeight))
        headView.image = UIImage(named: "fruit")
        return headView
    }()
    
    // 响应子控制器的tableView滚动
    var childVcScrollViewDidScrollClosure: ((scroll: UIScrollView, vc: PageTableViewController) -> Void)?
    
    /// 用来实时记录子控制器的tableView的滚动的offSetY
    var offSetY: CGFloat = -defaultOffSetY
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "简书个人主页"
        
        // 这个是必要的设置, 如果没有设置导致显示内容不正常, 请尝试设置这个属性
        automaticallyAdjustsScrollViewInsets = false
        
        // 1. 先添加contentView
        view.addSubview(contentView)
        // 2. 再添加headView
        view.addSubview(headView)
        // 3. 再添加topView
        view.addSubview(topView)
        
        
    }
    
    //1. 添加子控制器为PageTableViewController或者继承自他的Controller,
    //   或者你可以参考PageTableViewController他里面的实现自行实现(可以使用UICollectionView)相关的代理和属性 并且设置delegate为self
    
    
    func setChildVcs() -> [UIViewController] {
        let vc1 = PageTableViewController()
        
        vc1.delegate = self
        
        let vc2 = Test1Controller()
        vc2.delegate = self
        
        let vc3 = Test2Controller()
        vc3.delegate = self
        
        let vc4 = Test3Controller()
        vc4.delegate = self
        
        let vc5 = Test4Controller()
        vc5.delegate = self
        
        let vc6 = Test5Controller()
        vc6.delegate = self
        
        let vc7 = Test6Controller()
        vc7.delegate = self
        
        let vc8 = Test7Controller()
        vc8.delegate = self
        
        let vc9 = Test8Controller()
        vc9.delegate = self
        
        let vc10 = Test9Controller()
        vc10.delegate = self
        
        let vc11 = Test10Controller()
        vc11.delegate = self
        return [vc1, vc2, vc3,vc4, vc5, vc6, vc7, vc8, vc9, vc10, vc11]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


// MARK:- PageTableViewDelegate - 监控子控制器中的tableview的滚动和更新相关的UI
extension Vc8Controller: PageTableViewDelegate {
    
    // 设置将要显示的tableview的contentOffset.y
    func setupTableViewOffSetYWhenViewWillAppear(scrollView: UIScrollView) {
        
        if offSetY < -(naviBarHeight + segmentViewHeight) {
            scrollView.contentOffset.y = offSetY
        } else {
            if scrollView.contentOffset.y < -(naviBarHeight + segmentViewHeight) {
                scrollView.contentOffset.y = -(naviBarHeight + segmentViewHeight)
                // 使滑块停在navigationBar下面
                headView.frame.origin.y = naviBarHeight - headViewHeight
                topView.frame.origin.y = naviBarHeight
            }
        }

        print("\(offSetY)--------------")
        
    }
    
    // 根据子控制器的scrolView的偏移量来调整UI
    func scrollViewIsScrolling(scrollView: UIScrollView) {
        let deltaY =  scrollView.contentOffset.y - offSetY
        offSetY = scrollView.contentOffset.y
        
        
//        print(offSetY)
        
        if offSetY > -(defaultOffSetY - headViewHeight) {
            // 使滑块停在navigationBar下面
            headView.frame.origin.y = naviBarHeight - headViewHeight
            topView.frame.origin.y = naviBarHeight
            return
        } else if offSetY < -defaultOffSetY {
            
            // 使headView停在navigationBar下面
            headView.frame.origin.y = naviBarHeight
            topView.frame.origin.y = naviBarHeight + headViewHeight
            return
        }
        
        // 这里是让滑块和headView随着上下滚动
        headView.frame.origin.y -= deltaY
        topView.frame.origin.y -= deltaY
    }
    
}


// MARK:- ContentViewDelegate
extension Vc8Controller: ContentViewDelegate {
    var segmentView: ScrollSegmentView {
        return topView
    }
    
}

