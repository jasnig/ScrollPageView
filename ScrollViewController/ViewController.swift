//
//  ViewController.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["产不多", "国际要闻", "国际闻", "国际要闻", "国际要闻", "国际要闻", "国际要闻", "国际要闻", "国际要闻", "国际要闻", "国际要闻"]
        
        addChildVcs()
        
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        style.scrollLineColor = UIColor.redColor()
        style.coverBackgroundColor = UIColor.redColor()
        
        let scroll = ScrollPageView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64), segmentStyle: style, titles: titles, childVcs: childViewControllers)
        scroll.backgroundColor = UIColor.whiteColor()
        view.addSubview(scroll)
        
    }
    
    func addChildVcs() {
        let vc1 = storyboard!.instantiateViewControllerWithIdentifier("vc1")
        vc1.view.backgroundColor = UIColor.whiteColor()
//        let nav = UINavigationController(rootViewController: vc1)
        
        addChildViewController(vc1)
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.greenColor()
        addChildViewController(vc2)
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.yellowColor()
        addChildViewController(vc4)
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.redColor()
        addChildViewController(vc3)
        
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


}

