//
//  PPExampleViewController.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/7.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleItem.h"

@interface PPExampleViewController : UITableViewController
@property (nonatomic, strong) NSArray<ExampleItem *> *tableViewItems;
@end
