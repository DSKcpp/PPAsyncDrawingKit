一年 iOS，急需工作，快要露宿街头，上海地区，邮箱：dskcpp@gmail.com
PPAsyncDrawingKit
------------------------
这是一个轻量的异步绘制框架，实现一系列 `ImageView`, `Label`, `Button` 等基础控件，支持 `Objective-C`, `Swift`。

#Features
* 使用多线程技术进行绘制，保证复杂界面的流畅
* 不阻塞线程
* 使用简单
* 排版，渲染 `AttributedString`
* 异构 `TextView`，避免创建大量 `Label`
* 高性能圆角图片
* 保持 FPS 在低端设备上稳定在 60，减小抖动

#TODO
* 目前没有注释，过些日子补上
* Label 点击和计算有一些 BUG
* 多线程奇怪 BUG
* 一些小功能等待实现

#Requirements
* iOS 7.0 or later
* Xcode 7.3 or later

#How To Use
not impl
#Demo
将业务逻辑一样的文字渲染到一个 `View` 上，根据传入的多个 `AttributedString`，进行渲染。
左边只有一个 `View`。
![](http://ww4.sinaimg.cn/large/9bffd8f9gw1fbi1ji8hbyj21kw0u67fm.jpg)

#Installation
There are two ways to use PPAsyncDrawingKit in your project:

* using CocoaPods
* by cloning the project into your repository

###Installation with CocoaPods
####Podfile
`not impl`
``` Ruby
pod 'PPAsyncDrawingKit'
```

#Licenses
All source code is licensed under the [MIT License](https://raw.githubusercontent.com/DSKcpp/PPAsyncDrawingKit/master/LICENSE).






