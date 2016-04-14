//
//  vc1Controller.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/8.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class vc1Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        addChildVcs()
        
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 缩放文字
        style.scaleTitle = true
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // segment可以滚动
        style.scrollTitle = true
        
        let titles = ["国内头条", "国际要闻", "趣事", "囧图", "明星八卦", "爱车", "国防要事", "科技频道", "手机专页", "风景图", "段子"]
 
        let scroll = ScrollPageView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64), segmentStyle: style, titles: titles, childVcs: childViewControllers)
        view.addSubview(scroll)    
    }
    
    func addChildVcs() {
        let vc1 = storyboard!.instantiateViewControllerWithIdentifier("test")
        addChildViewController(vc1)
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.greenColor()
        addChildViewController(vc2)
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.redColor()
        addChildViewController(vc3)
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.yellowColor()
        addChildViewController(vc4)
        
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.lightGrayColor()
        addChildViewController(vc5)
        
        let vc6 = UIViewController()
        vc6.view.backgroundColor = UIColor.brownColor()
        addChildViewController(vc6)
        
        let vc7 = UIViewController()
        vc7.view.backgroundColor = UIColor.orangeColor()
        addChildViewController(vc7)
        
        let vc8 = UIViewController()
        vc8.view.backgroundColor = UIColor.blueColor()
        addChildViewController(vc8)
        
        
        let vc9 = UIViewController()
        vc9.view.backgroundColor = UIColor.brownColor()
        addChildViewController(vc9)
        
        let vc10 = UIViewController()
        vc10.view.backgroundColor = UIColor.orangeColor()
        addChildViewController(vc10)
        
        let vc11 = UIViewController()
        vc11.view.backgroundColor = UIColor.blueColor()
        addChildViewController(vc11)
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
