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

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 44, 80, 30)];
    [self.navigationController.navigationBar addSubview:fpsLabel];
    
    [[PPImageCache sharedCache] cleanDiskCache];
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

