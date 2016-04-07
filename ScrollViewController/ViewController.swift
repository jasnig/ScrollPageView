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
        
        let top = TopScrollView(frame:CGRect(x: 0, y: 100, width: view.bounds.size.width, height: 44))
        top.titles = ["产不多", "国际要闻", "好像可以用", "fsadfas", "fasdfasdfadf", "国际要闻", "好像可以用", "fsadfas", "国际要闻", "好像可以用", "fsadfas"]
        top.backgroundColor = UIColor.redColor()
        top.scrollLineColor = UIColor.greenColor()
        top.scrollLineHeight = 5
        
        view.addSubview(top)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

