一年 iOS，急需工作，快要露宿街头，上海地区，邮箱：dskcpp@gmail.com
PPAsyncDrawingKit
------------------------
[![Build Status](https://travis-ci.org/DSKcpp/PPAsyncDrawingKit.svg?branch=master)](https://travis-ci.org/DSKcpp/PPAsyncDrawingKit)

[![Languages](https://img.shields.io/badge/languages-ObjC%20%7C%20Swift-blue.svg)](https://github.com/DSKcpp/PPAsyncDrawingKit)
[![Platform](https://img.shields.io/badge/platforms-iOS%207.0%2B-blue.svg)](https://github.com/DSKcpp/PPAsyncDrawingKit)



这是一个轻量的异步绘制框架，实现一系列 `UIKit` 基础控件。

#Features
* 使用多线程技术进行绘制，不阻塞线程，保证复杂界面的流畅
* 高速滑动时，自动停止绘制
* 保持 FPS 在低端设备上稳定在 60，减小抖动
* 使用简单
* 高性能圆角图片
* 排版，绘制 `AttributedString` 富文本
* 异构 `TextView`，避免创建大量 `Label`


| UIKit | PPAsyncDrawingKit | More |
| --- | --- | --- |
| UIControl | PPControl |   |
| UILabel | PPTextView  | PPMultiplexTextView |
| UITextView | PPEditableTextView |   |
| UIImageView | PPImageView | PPWebImageView |
| UIButton | PPButton |   |


#TODO
* Editable text view
* Animation Image
* 目前没有注释，过些日子补上
* 更多的 CoreText 样式

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
高性能圆角 ImageView

如果不喜欢自带的`PPWebImageView`，支持 `SDWebImage`

![](http://ww4.sinaimg.cn/large/9bffd8f9gw1fbk3ht0t1zj20a108btat.jpg)

```Obj-C
PPImageView *imageView = [[PPImageView alloc] initWithFrame:CGRectMake(i * 45.0f, 5.0f, 40.0f, 40.0f)];
imageView.cornerRadius = 20.0f;
imageView.borderWidth = 0.1f;
imageView.borderColor = [UIColor blackColor];
imageView.contentMode = UIViewContentModeScaleAspectFill;
imageView.userInteractionEnabled = YES;
imageView.image = [UIImage imageNamed:@"avatar"];
[imageView addTarget:self action:@selector(tapImageView:) forControlEvents:UIControlEventTouchUpInside];
[self.contentView addSubview:imageView];

```
####PPWebImageView

```Obj-C
[imageView setImageURL:[NSURL URLWithString:@"url"] placeholderImage:[UIImage imageNamed:@"avatar"]];
```
####SDWebImage

```Obj-C
[imageView sd_setImageWithURL:[NSURL URLWithString:@"url"] placeholderImage:[UIImage imageNamed:@"avatar"]];
```

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
    
NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"(2016 年 10 月 27 日，加利福尼亚州，CUPERTINO) —— Apple® 今日推出了迄今为止最纤薄、最轻巧的 MacBook Pro®，并带来了创新的界面设计，以一条色彩绚丽、具备 Retina® 画质的 Multi-Touch™多点触控显示面板取代了以往键盘上排的功能键，这就是全新的 Multi-Touch Bar™。新一代 MacBook Pro 配备 Apple 迄今最明亮、最多彩的 Retina 显示屏，安全便捷的 Touch ID®，响应更灵敏的键盘，尺寸更大的 Force Touch 触控板，以及拥有双倍动态范围的音频系统。它还是有史以来性能最强大的 MacBook Pro：采用第六代四核和双核处理器，图形处理性能最高达前代机型的 2.3 倍，并拥有极其高速的固态硬盘和最多达四个 Thunderbolt 3 端口。"];
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
灰色区域表示绘制的最大 frame
黄色区域表示文字的真实 frame
红线表示 Base line
###PPMultiplexTextView
将多个 `AttributedString`，绘制到一个 `View` 上。

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






