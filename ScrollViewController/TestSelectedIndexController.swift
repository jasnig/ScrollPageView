//
//  TestSelectedIndexController.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/22.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class TestSelectedIndexController: UIViewController {

    // 返回响应
    var backClosure: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.titleView = setupBackBarItem()

    }
    
    func setupBackBarItem() -> UIButton {
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        backBtn.setTitle("返回选中其他页", forState: .Normal)
        backBtn.titleLabel?.textAlignment = .Center
        backBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        backBtn.addTarget(self, action: #selector(self.backBtnOnClick), forControlEvents: .TouchUpInside)
        
        return backBtn
        
    }

    func backBtnOnClick() {
        backClosure?()
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
