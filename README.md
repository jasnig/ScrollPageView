#ScrollPageView

![示例效果1.gif](http://upload-images.jianshu.io/upload_images/1271831-1cff5db09208a125.gif?imageMogr2/auto-orient/strip)  ![示例效果2.gif](http://upload-images.jianshu.io/upload_images/1271831-764800343e557870.gif?imageMogr2/auto-orient/strip)![示例效果3.gif](http://upload-images.jianshu.io/upload_images/1271831-b6ac95954eeb7c0e.gif?imageMogr2/auto-orient/strip)



![示例效果4.gif](http://upload-images.jianshu.io/upload_images/1271831-da735b7044a45139.gif?imageMogr2/auto-orient/strip) ![示例效果5.gif](http://upload-images.jianshu.io/upload_images/1271831-b3e7792f49df5897.gif?imageMogr2/auto-orient/strip)![示例效果6.gif](http://upload-images.jianshu.io/upload_images/1271831-ce881bb9245932b1.gif?imageMogr2/auto-orient/strip)

![示例效果7.gif](http://upload-images.jianshu.io/upload_images/1271831-d765bb375c887cd3.gif?imageMogr2/auto-orient/strip)



-----

### 可以简单快速灵活的实现上图中的效果


---

### 书写思路移步 [简书1](http://www.jianshu.com/p/b84f4dd96d0c)            [简书个人主页效果](http://www.jianshu.com/p/6be2597345e4)



---

### 使用方法

####一. 使用ScrollPageView , 提供了各种效果的组合,但是不能修改segmentView和ContentView的相对位置,两者是结合在一起的
	
	```
		//1. 添加子控制器,类似
		//let vc2 = UIViewController()
        //vc2.view.backgroundColor = UIColor.greenColor()
        //addChildViewController(vc2)
        
	     addChildVcs()
        
        // 2.这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        //3. 自定义效果组合
        var style = SegmentStyle()
        // 缩放文字
        style.scaleTitle = true
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // segment可以滚动
        style.scrollTitle = true
        // 4. 注意: 标题个数和子控制器的个数要相同
        let titles = ["国内头条", "国际要闻", "趣事", "囧图", "明星八卦", "爱车", "国防要事", "科技频道", "手机专页", "风景图", "段子"]
 		// 5.
        let scroll = ScrollPageView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64), segmentStyle: style, titles: titles, childVcs: childViewControllers)
        // 6.
        view.addSubview(scroll) 
	
	```
	
	
####二 使用 ScrollSegmentView 和 ContentView, 提供相同的效果组合, 但是同时可以分离开segmentView和contentView,可以单独设置他们的frame, 使用更灵活

		// 1. 添加子控制器
		addChildVcs()
        
        //2. 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        // 3. 自定义效果组合
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
		
		// 4. 标题个数和子控制器的个数要相同
        let titles = ["国内头条", "国际要闻"]

		// 5. 初始化segmentView
        topView = ScrollSegmentView(frame: CGRect(x: 0, y: 0, width: 150, height: 28), segmentStyle: style, titles: titles)
        topView.backgroundColor = UIColor.redColor()
        topView.layer.cornerRadius = 14.0
        // 可以直接设置背景色
        //        topView.backgroundImage = UIImage(named: "test")
		
		// 6. 初始化 contentView 
        contentView = ContentView(frame: view.bounds, childVcs: childViewControllers)
        // 7. 设置代理 必要的设置
        contentView.delegate = self // 必须实现代理方法
        
        // 8. 处理点击title时切换contentView的内容, 建议您可以直接使用和下面一样的代码
        topView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: false)
            
        }
        // 9. 添加segmentVIew 和ContentView
        navigationItem.titleView = topView
        view.addSubview(contentView)
        
        // 10. 实现代理, 只需要提供当前的segmentVIew即可
        
        extension Vc6Controller: ContentViewDelegate {
    		var segmentView: ScrollSegmentView {
       		 return topView
   		 	}
		}


###如果您在使用过程中遇到问题, 请联系我
####QQ:854136959 邮箱: 854136959@qq.com
####如果对您有帮助,请随手给个star鼓励一下 
