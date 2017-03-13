PPAsyncDrawingKit
------------------------
[![Build Status](https://travis-ci.org/DSKcpp/PPAsyncDrawingKit.svg?branch=master)](https://travis-ci.org/DSKcpp/PPAsyncDrawingKit)

[![Languages](https://img.shields.io/badge/languages-ObjC%20%7C%20Swift-blue.svg)](https://github.com/DSKcpp/PPAsyncDrawingKit)
[![Platform](https://img.shields.io/badge/platforms-iOS%207.0%2B-blue.svg)](https://github.com/DSKcpp/PPAsyncDrawingKit)
[![Xcode](https://img.shields.io/badge/Xcode-8.0%2B-blue.svg)](https://github.com/DSKcpp/PPAsyncDrawingKit)


这是一个轻量的异步绘制框架，实现一系列 `UIKit` 基础控件。

关于 Core Text 结构问题：[Apple Dev (About Core Text)](https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/CoreText_Programming/Introduction/Introduction.html#//apple_ref/doc/uid/TP40005533-CH1-SW1)

#Features
* 使用多线程技术进行绘制，不阻塞线程，保证复杂界面的流畅
* 高速滑动时，自动停止绘制
* 保持 FPS 在低端设备上稳定在 60，减小抖动
* 使用简单
* 高性能圆角图片
* 排版，绘制富文本
* 一次性绘制多个富文本到同一个 `view` 上，减少创建多个 `view`


| UIKit | PPAsyncDrawingKit | Feature |
| --- | --- | --- |
| UIControl | PPControl |   |
| UILabel | PPTextView  | PPMultiplexTextView |
| UITextView | PPEditableTextView |   |
| UIImageView | PPImageView  |
| UIButton | PPButton |   |


#TODO
* Editable text view
* Animation Image
* 完善注释
* 更多的 CoreText 样式

#Demo
为了达到效果，请在真机运行 Demo。

在复杂的场景下高速滑动 FPS 对比:

* 测试环境 iPhone 5 (iOS 10.2)
* 使用多线程进行绘制，基本能稳定在60 左右
* 在主线程进行绘制，抖动较大，有非常明显的卡顿

![](http://ww4.sinaimg.cn/large/9bffd8f9jw1fcde9s4ac1j20jy0jsdh7.jpg)

###PPMultiplexTextView
将多个`AttributedString`根据各自的`frame`合并到同一个`view`上，并且支持交互。

####新浪微博Example：Project/Feeds Demo/View
![](http://ww4.sinaimg.cn/large/9bffd8f9gw1fbi1ji8hbyj21kw0u67fm.jpg)

####微信朋友圈Example：project/Text Example/PPMultiplexTextExample.m
![](http://wx3.sinaimg.cn/large/9bffd8f9gy1fcvr993f39j20ku0fjdgo.jpg)

层次结构：

![](http://wx1.sinaimg.cn/large/9bffd8f9gy1fcwtei82e7g20aw084aap.gif)

###PPTextView
```Obj-C
CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 24.0f, CGFLOAT_MAX);

NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"@谷大白话:Super Moon"];
[attributedString pp_setFont:[UIFont systemFontOfSize:15.0f]];

PPTextView *textView = [[PPTextView alloc] init];

// 下面 2 个方法可以获取文字的大小
// PPTextLayout *textLayout = [PPTextLayout new];
// textLayout.attributedString = attributedString;
// textLayout.maxSize = maxSize;
// CGSize textSize = textLayout.layoutSize;
OR
// CGSize textSize = [attributedString pp_sizeConstrainedToSize:maxSize];

// 下面 2 个方法可以设置文字
// textView.textLayout = textLayout;
OR
// textView.attributedString = attributedString;

textView.frame = CGRectMake(0, 0, textSize.width, textSize.height) textLayout.layoutSize;
[self.view addSubview:textView];
```
####Highlight
![](http://wx1.sinaimg.cn/mw690/9bffd8f9gy1fc3swnwu13j20cs01omwy.jpg)

```Obj-C
PPTextHighlightRange *highlightRange = [[PPTextHighlightRange alloc] init];
[attributedString pp_setTextHighlightRange:highlightRange inRange:NSMakeRange(0, 5)];
```
####Border
![](http://wx1.sinaimg.cn/mw690/9bffd8f9gy1fc3swo0s44j20cs01omwy.jpg)

```Obj-C
PPTextBorder *border = [[PPTextBorder alloc] init];
border.fillColor = [UIColor redColor];
[highlightRange setBorder:border];
```
####Truncated Line
![](http://wx2.sinaimg.cn/large/9bffd8f9gy1fc3swnrx05j20ku066wes.jpg)

```Obj-C
    
NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"balabala"];
[attributedString pp_setFont:[UIFont systemFontOfSize: 15.0f]];
[attributedString pp_setColor:[UIColor blackColor]];
    
PPTextLayout *textLayout = [PPTextLayout new];
textLayout.attributedString = attributedString;
textLayout.numberOfLines = 5;
textLayout.maxSize = maxSize;
    
PPTextView *textView = [[PPTextView alloc] init];
textView.textLayout = textLayout;
textView.size = textLayout.layoutSize;
textView.left = 12.0f;
textView.top = 76.0f;
[self.view addSubview:textView];
```

#### Text Renderer DEBUG
![](http://ww4.sinaimg.cn/large/9bffd8f9jw1fcdbxioilij20ku05b3z7.jpg)

```Obj-C
[PPTextRenderer setDebugModeEnabled:YES];
```

灰色区域表示绘制的最大 frame，黄色区域表示文字的真实 frame，红线表示 Base line
###PPImageView
高性能圆角图片，自带缓存和下载图片，也支持SDWebImage。

![](http://ww4.sinaimg.cn/large/9bffd8f9gw1fbk3ht0t1zj20a108btat.jpg)

#Installation with CocoaPods
###Podfile
`暂时没有上传，等基本完成和测试之后再提交`
``` Ruby
pod 'PPAsyncDrawingKit'
```

#Licenses
All source code is licensed under the [MIT License](https://raw.githubusercontent.com/DSKcpp/PPAsyncDrawingKit/master/LICENSE).






