//
//  ViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewTableViewController.h"
#import "WBTimeLineViewController.h"
#import "TextViewController.h"
#import "PPAsyncDrawingKitUtilities.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hex16ToFloat(0x7f800000);
    CGFloat i = 1;
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@""];
    a.repeatCount = 1;
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
        WBTimeLineViewController * viewController = [[WBTimeLineViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

