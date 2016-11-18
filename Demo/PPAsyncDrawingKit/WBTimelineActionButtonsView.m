//
//  WBTimelineActionButtonsView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineActionButtonsView.h"
#import "PPButton.h"

@implementation WBTimelineActionButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initActionButtons];
    }
    return self;
}

- (void)initActionButtons
{
    
    PPButton *forwardButton = [[PPButton alloc] initWithFrame:CGRectMake(0, 0, 320, 34)];
    [forwardButton setTitle:@"转发 0" forState:UIControlStateNormal];
    [self addSubview:forwardButton];
}
@end
