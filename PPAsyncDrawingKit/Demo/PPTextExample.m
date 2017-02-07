//
//  PPTextExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextExample.h"
#import "PPTextAttributedExample.h"
#import "PPTextEditableExample.h"
#import "PPTextTruncatedExample.h"

@implementation PPTextExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableViewItems = @[[ExampleItem t:@"Text Attributed Example" c:[PPTextAttributedExample class]],
                            [ExampleItem t:@"Text Truncated Example" c:[PPTextTruncatedExample class]],
                            [ExampleItem t:@"Text Editable Example" c:[PPTextEditableExample class]]];
}
@end
