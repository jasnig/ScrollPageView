//
//  Vc6Controller.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/13.
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

class Vc6Controller: UIViewController {

    var topView: ScrollSegmentView!
    var contentView: ContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        
        // 标题不滚动, 则每个label会平分宽度
        style.scrollTitle = false
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

        let titles = setChildVcs().map { (childVc) -> String in
            childVc.title!
        }

        topView = ScrollSegmentView(frame: CGRect(x: 0, y: 0, width: 150, height: 28), segmentStyle: style, titles: titles)
        topView.backgroundColor = UIColor.redColor()
        topView.layer.cornerRadius = 14.0
        // 可以直接设置背景色
        //        topView.backgroundImage = UIImage(named: "test")

        contentView = ContentView(frame: view.bounds, childVcs: setChildVcs(), parentViewController: self)
        contentView.delegate = self // 必须实现代理方法
        
        topView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: false)
            
        }
        
        
        navigationItem.titleView = topView
        view.addSubview(contentView)
        
        // 用于测试刷新视图
        let btn = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 44))
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setTitle("测试刷新", forState: .Normal)
        btn.addTarget(self, action: #selector(self.reloadChildVcs), forControlEvents: .TouchUpInside)
        view.addSubview(btn)
    }
    
    func reloadChildVcs() {
        
        // 设置新的childVcs
        let vc1 = storyboard!.instantiateViewControllerWithIdentifier("test")
        vc1.view.backgroundColor = UIColor.redColor()
        vc1.title = "更换标题"

        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.greenColor()
        vc2.title = "换标题2"

        let newChildVcs = [vc1, vc2]
        // 设置新的标题
        let newTitles = newChildVcs.map {
            $0.title!
        }
        topView.reloadTitlesWithNewTitles(newTitles)
        contentView.reloadAllViewsWithNewChildVcs(newChildVcs)
//        topView.selectedIndex(1, animated: true)
    }
    
    // 设置childVcs
    func setChildVcs()  -> [UIViewController]{
        let vc1 = storyboard!.instantiateViewControllerWithIdentifier("test")
        vc1.view.backgroundColor = UIColor.whiteColor()
        vc1.title = "国内头条"
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.greenColor()
        vc2.title = "国际头条"

        return [vc1, vc2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Vc6Controller: ContentViewDelegate {
    var segmentView: ScrollSegmentView {
        return topView
    }
}