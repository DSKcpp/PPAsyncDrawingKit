//
//  PPImageExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/7.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPImageExample.h"
#import "PPImageViewRoundedExample.h"
#import "PPImageViewAnimationExample.h"

@implementation PPImageExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableViewItems = @[[ExampleItem t:@"Rounded Image Example" c:[PPImageViewRoundedExample class]],
                            [ExampleItem t:@"Animation Image Example" c:[PPImageViewAnimationExample class]]];
}
@end
