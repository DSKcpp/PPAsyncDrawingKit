//
//  PPTextExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextExample.h"

@implementation PPTextExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableViewItems = @[[ExampleItem t:@"Text Attributed Example" c:@"PPTextAttributedExample"],
                            [ExampleItem t:@"Text Truncated Example" c:@"PPTextTruncatedExample"],
                            [ExampleItem t:@"Multiplex Text Example Example" c:@"PPMultiplexTextExample"],
                            [ExampleItem t:@"Text Editable Example" c:@"PPTextEditableExample"]];
}
@end
