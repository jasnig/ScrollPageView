
//
//  Vc10Controller.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/29.
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

class Vc10Controller: UIViewController {

    // 首先生成所有的allChildVcs 和对应的title
    lazy var allChildVcs: [UIViewController] = {
        let vc1 = self.storyboard!.instantiateViewControllerWithIdentifier("test")
        vc1.title = "国内头条"
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.greenColor()
        vc2.title = "国际要闻"
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.redColor()
        vc3.title = "趣事"
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.yellowColor()
        vc4.title = "囧图"
        
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.lightGrayColor()
        vc5.title = "明星八卦"
        
        let vc6 = UIViewController()
        vc6.view.backgroundColor = UIColor.brownColor()
        vc6.title = "爱车"
        
        let vc7 = UIViewController()
        vc7.view.backgroundColor = UIColor.orangeColor()
        vc7.title = "国防要事"
        
        let vc8 = UIViewController()
        vc8.view.backgroundColor = UIColor.blueColor()
        vc8.title = "科技频道"
        
        let vc9 = UIViewController()
        vc9.view.backgroundColor = UIColor.brownColor()
        vc9.title = "手机专页"
        
        let vc10 = UIViewController()
        vc10.view.backgroundColor = UIColor.orangeColor()
        vc10.title = "风景图"
        
        let vc11 = UIViewController()
        vc11.view.backgroundColor = UIColor.blueColor()
        vc11.title = "段子"
        
        
        let vc12 = UIViewController()
        vc12.view.backgroundColor = UIColor.greenColor()
        vc12.title = "美女"
        
        let vc13 = UIViewController()
        vc13.view.backgroundColor = UIColor.redColor()
        vc13.title = "体育"
        
        let vc14 = UIViewController()
        vc14.view.backgroundColor = UIColor.yellowColor()
        vc14.title = "热点"
        
        let vc15 = UIViewController()
        vc15.view.backgroundColor = UIColor.lightGrayColor()
        vc15.title = "财经"
        
        let vc16 = UIViewController()
        vc16.view.backgroundColor = UIColor.brownColor()
        vc16.title = "时尚"
        
        let vc17 = UIViewController()
        vc17.view.backgroundColor = UIColor.orangeColor()
        vc17.title = "房产"
        
        let vc18 = UIViewController()
        vc18.view.backgroundColor = UIColor.blueColor()
        vc18.title = "独家"
        
        let vc19 = UIViewController()
        vc19.view.backgroundColor = UIColor.brownColor()
        vc19.title = "中国足球"
        
        let vc20 = UIViewController()
        vc20.view.backgroundColor = UIColor.orangeColor()
        vc20.title = "社会"
        
        let vc21 = UIViewController()
        vc21.view.backgroundColor = UIColor.blueColor()
        vc21.title = "历史"
        
        return [vc1, vc2, vc3,vc4, vc5, vc6, vc7, vc8, vc9, vc10, vc11, vc12, vc13,vc14, vc15, vc16, vc17, vc18, vc19, vc20, vc21]
    }()
    
    var currentChildVcs: [UIViewController] = []
    
    var scrollPageView: ScrollPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 遮盖
        style.showCover = true
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 遮盖颜色
        style.coverBackgroundColor = UIColor.lightGrayColor()
        
        /// 显示附加按钮
        style.showExtraButton = true
        
        /// 设置附加按钮的背景图片
        style.extraBtnBackgroundImageName = "extraBtnBackgroundImage"
        
        // 设置初始数据
        currentChildVcs = setChildVcs()
        let titles = currentChildVcs.map{ $0.title! }
        
        scrollPageView = ScrollPageView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64), segmentStyle: style, titles: titles, childVcs: currentChildVcs, parentViewController: self)
        
        scrollPageView.extraBtnOnClick = {[unowned self] (extraBtn: UIButton) in
            // 捕获到self.currentChildVcs
            let allTitles = self.allChildVcs.map { $0.title! }
            
            let selectedTitles = self.currentChildVcs.map{ $0.title! }
            
            let unselectedTitles = allTitles.filter({ (title) -> Bool in
                return !selectedTitles.contains(title)
            })
            
            
            let selectionView = SelectionView(frame: CGRect(x: 0.0, y: 64.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64.0), selectedTitles: selectedTitles, unselectedTitles: unselectedTitles, finishAction: {[unowned self] (selectedTitles) in
                // 设置新的数据
                self.resetChildVcs(selectedTitles)
                // 刷新视图显示
                self.reloadChildVcs()
            })
            
//            selectionView.alpha = 0.9
            self.view.addSubview(selectionView)
            selectionView.show()
            
        }
        view.addSubview(scrollPageView)
    }
    
    
    // 刷新视图
    func reloadChildVcs() {
        let newChildVcs = currentChildVcs
        let newTitles = currentChildVcs.map { $0.title! }
        // 调用public方法刷新视图
        scrollPageView.reloadChildVcsWithNewTitles(newTitles, andNewChildVcs: newChildVcs)
    }
    
    // 重新设置ChildVcs
    func resetChildVcs(newTitles: [String]) {
        currentChildVcs = newTitles.map { (newTitle) -> UIViewController in
            // 通过遍历相应的title得到对应的UIViewController
            for childVc in self.allChildVcs {
                if childVc.title! == newTitle {// 如果title相等时, 证明是想要的childVc
                    return childVc
                }
            }
            
            assert(false, "有控制器的标题设置不正确")
            // 如果控制器的标题对应设置正确, 是不会执行下面的
            return UIViewController()
        }
    }
    
    func setChildVcs() -> [UIViewController] {
        let vc1 = storyboard!.instantiateViewControllerWithIdentifier("test")
        vc1.title = "国内头条"
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.greenColor()
        vc2.title = "国际要闻"

        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.redColor()
        vc3.title = "趣事"

        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.yellowColor()
        vc4.title = "囧图"

        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.lightGrayColor()
        vc5.title = "明星八卦"

        let vc6 = UIViewController()
        vc6.view.backgroundColor = UIColor.brownColor()
        vc6.title = "爱车"

        let vc7 = UIViewController()
        vc7.view.backgroundColor = UIColor.orangeColor()
        vc7.title = "国防要事"

        let vc8 = UIViewController()
        vc8.view.backgroundColor = UIColor.blueColor()
        vc8.title = "科技频道"

        let vc9 = UIViewController()
        vc9.view.backgroundColor = UIColor.brownColor()
        vc9.title = "手机专页"

        let vc10 = UIViewController()
        vc10.view.backgroundColor = UIColor.orangeColor()
        vc10.title = "风景图"

        let vc11 = UIViewController()
        vc11.view.backgroundColor = UIColor.blueColor()
        vc11.title = "段子"

        return [vc1, vc2, vc3,vc4, vc5, vc6, vc7, vc8, vc9, vc10, vc11]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
