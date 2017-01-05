//
//  ViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewTableViewController.h"
#import "WBTimelineViewController.h"
#import "TextViewController.h"
#import "PPAsyncDrawingKitUtilities.h"
#import "YYFPSLabel.h"
#import "PPImageCache.h"
#import "PPWebImageManager.h"
#import "PPAsyncDrawingView.h"
#import "UIView+Frame.h"
#import "PPTextRenderer.h"

@interface PPDemoToolBar : UIView

@end

@implementation PPDemoToolBar
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(10.0f, 0, 60, 20)];
        fpsLabel.centerY = self.height / 2.0f;
        [self addSubview:fpsLabel];
        
        UILabel *asyncLabel = [[UILabel alloc] init];
        asyncLabel.text = @"Async:";
        asyncLabel.font = [UIFont systemFontOfSize:14.0f];
        [asyncLabel sizeToFit];
        asyncLabel.centerY = fpsLabel.centerY;
        asyncLabel.left = fpsLabel.right + 10.0f;
        [self addSubview:asyncLabel];      
        
        UISwitch *asyncSwitch = [[UISwitch alloc] init];
        asyncSwitch.centerY = fpsLabel.centerY;
        asyncSwitch.left = asyncLabel.right;
        [asyncSwitch.layer setValue:@(0.8) forKeyPath:@"transform.scale"];
        [asyncSwitch setOn:![PPAsyncDrawingView asyncDrawingDisabledGlobally] animated:YES];
        [asyncSwitch addTarget:self action:@selector(setAsyncDrawingDisabledGlobally:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:asyncSwitch];
        
        UILabel *textDebugLabel = [[UILabel alloc] init];
        textDebugLabel.text = @"Text DEBUG:";
        textDebugLabel.font = [UIFont systemFontOfSize:14.0f];
        [textDebugLabel sizeToFit];
        textDebugLabel.centerY = fpsLabel.centerY;
        textDebugLabel.left = asyncSwitch.right + 10.0f;
        [self addSubview:textDebugLabel];
        
        UISwitch *textDebugSwitch = [[UISwitch alloc] init];
        textDebugSwitch.centerY = fpsLabel.centerY;
        textDebugSwitch.left = textDebugLabel.right;
        [textDebugSwitch.layer setValue:@(0.8) forKeyPath:@"transform.scale"];
        [textDebugSwitch setOn:[PPTextRenderer debugModeEnabled] animated:YES];
        [textDebugSwitch addTarget:self action:@selector(setTextRendererDebug:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:textDebugSwitch];
    }
    return self;
}

- (void)setAsyncDrawingDisabledGlobally:(UISwitch *)switchButton
{
    [PPAsyncDrawingView setAsyncDrawingDisabledGlobally:!switchButton.isOn];
}

- (void)setTextRendererDebug:(UISwitch *)switchButton
{
    [PPTextRenderer setDebugModeEnabled:switchButton.isOn];
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat height = 35.0f;
    PPDemoToolBar *toolBar = [[PPDemoToolBar alloc] initWithFrame:CGRectMake(0, self.view.bottom - height, self.view.width, height)];
    [[UIApplication sharedApplication].keyWindow addSubview:toolBar];
    
//    [[PPImageCache sharedCache] cleanDiskCache];
//    NSUInteger size =  [[PPImageCache sharedCache] cacheSize];
//    NSLog(@"%zd", size);
//    [[PPImageCache sharedCache] storeImage:[UIImage imageNamed:@"avatar"] data:nil forURL:@"https://dskcpp.github.io" toDisk:YES];
//    UIImage *image = [[PPImageCache sharedCache] imageForURL:@"https://dskcpp.github.io"];
////    NSLog(@"%@", image);
//    
//    [[PPWebImageManager sharedManager] loadImage:@"http://ww2.sinaimg.cn/large/62cc3323gw1fb22c4thosj21jk0rs1kx.jpg" complete:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
//        NSLog(@"%@", image);
//    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ImageViewTableViewController * viewController = [[ImageViewTableViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 1) {
        TextViewController * viewController = [[TextViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 2) {
        WBTimelineViewController * viewController = [[WBTimelineViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

