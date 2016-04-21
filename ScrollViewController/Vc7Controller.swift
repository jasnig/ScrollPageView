//
//  Vc7Controller.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/20.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class Vc7Controller: UIViewController {

    let segmentViewHeight = 44.0
    let naviBarHeight = 64.0
    let headViewHeight = 200.0
    
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
        
        let topView = ScrollSegmentView(frame: CGRect(x: 0.0, y: 0.0, width: Double(self.view.bounds.size.width), height: self.segmentViewHeight), segmentStyle: style, titles: titles)
        
        topView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: false)
            
        }
        

        
        topView.backgroundColor = UIColor.lightGrayColor()
        return topView
        
    }()
    
    // 懒加载contentView
    lazy var contentView: ContentView! = {[unowned self] in
        // 注意, 如果tableview是在storyboard中来的, 设置contentView的高度和这里不一样
        let contentView = ContentView(frame: CGRect(x: 0.0, y: 0.0, width: Double(self.view.bounds.size.width), height: Double(self.view.bounds.size.height) - self.naviBarHeight - self.segmentViewHeight), childVcs: self.childViewControllers)
        contentView.delegate = self // 必须实现代理方法
        return contentView
    }()
    
    // 懒加载tableView, 注意如果是从storyBoard中连线过来的,那么注意设置contentView的高度有点不一样
    // 或者在滚动的时候需要渐变navigationBar的时候,需要注意相关的tableView的frame设置和contentInset的设置
    lazy var tableView: UITableView = {[unowned self] in
        let table = UITableView(frame: CGRect(x: 0.0, y: self.naviBarHeight, width: Double(self.view.bounds.size.width), height: Double(self.view.bounds.size.height) - self.naviBarHeight), style: .Plain)
        table.delegate = self
        table.dataSource = self
        return table
        
    }()
    
    
    var test: ((scroll: UIScrollView) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "简书个人主页"

        addChildVcs()

        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        // 设置tableView的headView
        tableView.tableHeaderView = setTableViewHeadView()
        tableView.tableFooterView = UIView()
        // 设置cell行高为contentView的高度
        tableView.rowHeight = contentView.bounds.size.height
        // 设置tableView的sectionHeadHeight为segmentViewHeight
        tableView.sectionHeaderHeight = CGFloat(segmentViewHeight)
        view.addSubview(tableView)
    }
    
    
    func setTableViewHeadView() -> UIImageView {
        let headView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: Double(view.bounds.size.width), height: headViewHeight))
        headView.image = UIImage(named: "fruit")
        return headView
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
    

}

// MARK:- UITableViewDataSource UITableViewDelegate
extension Vc7Controller: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cellId")
        
        cell.contentView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        
        cell.contentView.addSubview(contentView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return topView
    }
    
}


// MARK:- UIScrollViewDelegate 这里的代理可以监控tableView的滚动, 在滚动的时候就可以做一些事情, 比如使navigationBar渐变, 或者像简书一样改变头像的属性
extension Vc7Controller: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("gundong --------")
    }
}

// MARK:- ContentViewDelegate
extension Vc7Controller: ContentViewDelegate {
    var segmentView: ScrollSegmentView {
        return topView
    }
    
    // 监控开始滚动contentView的时候, 这里将滚动条滚动至顶部(简书没有这个效果,但其他的有---这里拒绝广告)
    func contentViewDidBeginMove() {
        tableView.setContentOffset(CGPoint(x: 0.0, y: headViewHeight), animated: true)
    }
    
}