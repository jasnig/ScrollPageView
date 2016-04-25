//
//  TestSelectedIndexController.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/22.
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

class TestSelectedIndexController: UIViewController {

    // 返回响应
    var backClosure: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = setupBackBarItem()

    }
    
    func setupBackBarItem() -> UIBarButtonItem {
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        backBtn.setTitle("返回选中其他页", forState: .Normal)
        backBtn.titleLabel?.textAlignment = .Center
        backBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        backBtn.addTarget(self, action: #selector(self.backBtnOnClick), forControlEvents: .TouchUpInside)
        
        return UIBarButtonItem(customView: backBtn)
        
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
