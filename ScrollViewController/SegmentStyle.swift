//
//  SegmentStyle.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/p/b84f4dd96d0c

import UIKit


struct SegmentStyle {
    /// 是否显示遮盖
    var showCover = false
    /// 是否显示下划线
    var showLine = false
    /// 是否缩放文字
    var scaleTitle = false
    /// 是否可以滚动标题
    var scrollTitle = true
    /// 是否颜色渐变
    var gradualChangeTitleColor = false
    
    /// 下面的滚动条的高度 默认2
    var scrollLineHeight: CGFloat = 2
    /// 下面的滚动条的颜色
    var scrollLineColor = UIColor.brownColor()
    
    /// 遮盖的背景颜色
    var coverBackgroundColor = UIColor.lightGrayColor()
    /// 遮盖圆角
    var coverCornerRadius = 14.0
    
    /// cover的高度 默认28
    var coverHeight: CGFloat = 28.0
    /// 文字间的间隔 默认15
    var titleMargin: CGFloat = 15
    /// 文字 字体 默认14.0
    var titleFont = UIFont.systemFontOfSize(14.0)
    
    /// 放大倍数 默认1.3
    var titleBigScale: CGFloat = 1.3
    /// 默认倍数 不可修改
    let titleOriginalScale: CGFloat = 1.0
    
    /// 文字正常状态颜色 请使用RGB空间的颜色值!! 如果提供的不是RGB空间的颜色值就可能crash
    var normalTitleColor = UIColor(red: 51.0/255.0, green: 53.0/255.0, blue: 75/255.0, alpha: 1.0)
    /// 文字选中状态颜色 请使用RGB空间的颜色值!! 如果提供的不是RGB空间的颜色值就可能crash
    var selectedTitleColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 121/255.0, alpha: 1.0)
    
}