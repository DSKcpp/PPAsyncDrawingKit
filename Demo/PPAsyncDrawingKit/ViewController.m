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

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 44, 80, 30)];
    [self.navigationController.navigationBar addSubview:fpsLabel];
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

