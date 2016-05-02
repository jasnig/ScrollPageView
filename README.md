#ScrollPageView

##使用示例效果

![更新示例.gif](http://upload-images.jianshu.io/upload_images/1271831-fedc212e01f79347.gif?imageMogr2/auto-orient/strip) ![示例效果1.gif](http://upload-images.jianshu.io/upload_images/1271831-1cff5db09208a125.gif?imageMogr2/auto-orient/strip)  ![示例效果2.gif](http://upload-images.jianshu.io/upload_images/1271831-764800343e557870.gif?imageMogr2/auto-orient/strip)![示例效果3.gif](http://upload-images.jianshu.io/upload_images/1271831-b6ac95954eeb7c0e.gif?imageMogr2/auto-orient/strip)



![示例效果4.gif](http://upload-images.jianshu.io/upload_images/1271831-da735b7044a45139.gif?imageMogr2/auto-orient/strip) ![示例效果5.gif](http://upload-images.jianshu.io/upload_images/1271831-b3e7792f49df5897.gif?imageMogr2/auto-orient/strip)![示例效果6.gif](http://upload-images.jianshu.io/upload_images/1271831-ce881bb9245932b1.gif?imageMogr2/auto-orient/strip)

![示例效果7.gif](http://upload-images.jianshu.io/upload_images/1271831-d765bb375c887cd3.gif?imageMogr2/auto-orient/strip) ![示例效果8.gif](http://upload-images.jianshu.io/upload_images/1271831-482997456d1f4578.gif?imageMogr2/auto-orient/strip) ![自定义下标效果.gif](http://upload-images.jianshu.io/upload_images/1271831-d92a7cbf6737066e.gif?imageMogr2/auto-orient/strip)



-----

### 可以简单快速灵活的实现上图中的效果


---

### 书写思路移步
###[简书1](http://www.jianshu.com/p/b84f4dd96d0c)            
###[简书2](http://www.jianshu.com/p/6be2597345e4) 
###[简书3](http://www.jianshu.com/p/273ee7c2a0f5)



---

## Requirements

* iOS 8.0+ 
* Xcode 7.3 or above

## Installation

### CocoaPods
####1.在你的项目Podfile里面添加下面的内容

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'ScrollPageView', '~> 0.1.1'

###2.终端中执行命令 pod install
###3. 使用{Project}.xcworkspace打开项目


---
###或者直接下载将下载文件的ScrollPageView文件夹下的文件拖进您的项目中就可以使用了

###Usage
---
###如果是使用cocoapods安装的需要在使用的文件中
###import ScrollPageView
---


###Update (更新说明) -- 2016/04/29
 * 废弃了前面版本的使用方法(前面使用过的朋友请修改为新的使用方法), 提供了更合理的使用方法, 不需要addChildViewController, 只需要提供一个addChildViewControllers的数组即可
 * 添加了更新titles和childViewControllers的方法, 可以动态的修改和更新显示的内容

####一. 使用ScrollPageView , 提供了各种效果的组合,但是不能修改segmentView和ContentView的相对位置,两者是结合在一起的


		//1. 设置子控制器,类似
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
        
        let childVcs = setChildVcs()
        // 4. 注意: 标题个数和子控制器的个数要相同
        let titles = childVcs.map { $0.title! }

 		// 5. 这里的childVcs 需要传入一个包含childVcs的数组, parentViewController 传入self
        let scrollPageView = ScrollPageView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64), segmentStyle: style, titles: titles, childVcs: childVcs, parentViewController: self)
        // 6.
        view.addSubview(scroll) 
	

	
	
####二 使用 ScrollSegmentView 和 ContentView, 提供相同的效果组合, 但是同时可以分离开segmentView和contentView,可以单独设置他们的frame, 使用更灵活


			// 1. 添加子控制器
			    // 设置childVcs
   		 func setChildVcs()  -> [UIViewController]{
        	let vc1 = storyboard!.instantiateViewControllerWithIdentifier("test")
        	vc1.view.backgroundColor = UIColor.whiteColor()
        
        	let vc2 = UIViewController()
        	vc2.view.backgroundColor = UIColor.greenColor()
        
       		 return [vc1, vc2]
   		 }
        
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
        contentView = ContentView(frame: view.bounds, childVcs: setChildVcs(), parentViewController: self)
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
		
		
三. 更新方法的使用:

* 
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

* 

	    let newChildVcs = currentChildVcs
        let newTitles = currentChildVcs.map { $0.title! }
        // 调用public方法刷新视图
        scrollPageView.reloadChildVcsWithNewTitles(newTitles, andNewChildVcs: newChildVcs)


###如果您在使用过程中遇到问题, 请联系我
####QQ:854136959 邮箱: 854136959@qq.com
####如果对您有帮助,请随手给个star鼓励一下 

## License

ScrollPageView is released under the MIT license. See LICENSE for details.
