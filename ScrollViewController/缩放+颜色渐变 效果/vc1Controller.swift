//
//  vc1Controller.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/8.
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

class vc1Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 缩放文字
        style.scaleTitle = true
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // segment可以滚动
        style.scrollTitle = true
        style.showExtraButton = true
        
        let titles = setChildVcs().map { $0.title! }
 
        let scrollPageView = ScrollPageView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64), segmentStyle: style, titles: titles, childVcs: setChildVcs(), parentViewController: self)
        view.addSubview(scrollPageView)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
