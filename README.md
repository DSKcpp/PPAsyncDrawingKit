一年 iOS，急需工作，快要露宿街头，上海地区，邮箱：dskcpp@gmail.com
PPAsyncDrawingKit
------------------------
[![Build Status](https://travis-ci.org/DSKcpp/PPAsyncDrawingKit.svg?branch=master)](https://travis-ci.org/DSKcpp/PPAsyncDrawingKit)

这是一个轻量的异步绘制框架，实现一系列 `ImageView`, `Label`, `Button` 等基础控件，支持 `Objective-C`, `Swift`。

#Features
* 使用多线程技术进行绘制，不阻塞线程，保证复杂界面的流畅
* 高速滑动时，自动停止渲染
* 保持 FPS 在低端设备上稳定在 60，减小抖动
* 使用简单
* 高性能圆角图片
* 排版，渲染 `AttributedString`
* 异构 `TextView`，避免创建大量 `Label`


#TODO
* 目前没有注释，过些日子补上
* Label 点击和计算有一些 BUG
* 更多的 CoreText 样式

#Requirements
* iOS 7.0 or later
* Xcode 8.0 or later

#How To Use
see `Demo\PPAsyncDrawingKit.xcodeproj`

#Demo
为了达到效果，请在真机运行 Demo。

在复杂的场景下高速滑动 FPS 对比:

* 测试环境 iPhone 5 (iOS 10.2)
* 使用多线程进行绘制，基本能稳定在60 左右
* 在主线程进行绘制，抖动较大，有非常明显的卡顿

![](http://ww2.sinaimg.cn/large/9bffd8f9gw1fbka8hdcusj20ks0jugmz.jpg)

###PPImageView
高性能圆角 ImageView, 滑动时FPS 稳定 60

![](http://ww4.sinaimg.cn/large/9bffd8f9gw1fbk3ht0t1zj20a108btat.jpg)

###PPIsomerismTextView
利用 `CoreText` 将传入的多个 `AttributedString`，渲染到一个 `View` 上。

左边只有一个 `View`。
![](http://ww4.sinaimg.cn/large/9bffd8f9gw1fbi1ji8hbyj21kw0u67fm.jpg)

#Installation
There are two ways to use PPAsyncDrawingKit in your project:

* using CocoaPods
* by cloning the project into your repository

###Installation with CocoaPods
####Podfile
`暂时没有上传，等基本完成和测试之后再提交`
``` Ruby
pod 'PPAsyncDrawingKit'
```

#Licenses
All source code is licensed under the [MIT License](https://raw.githubusercontent.com/DSKcpp/PPAsyncDrawingKit/master/LICENSE).






