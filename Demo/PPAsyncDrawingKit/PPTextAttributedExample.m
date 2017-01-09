//
//  PPTextAttributedExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/9.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTextAttributedExample.h"
#import "UIView+Frame.h"
#import "PPLabel.h"

@interface PPTextAttributedExample ()

@end

@implementation PPTextAttributedExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Highligh"];
    [attributedString pp_setFont:[UIFont boldSystemFontOfSize:30.0f]];
    [attributedString pp_setAlignment:NSTextAlignmentCenter];
    PPTextHighlightRange *highlightRange = [[PPTextHighlightRange alloc] init];
    PPTextBorder *border = [[PPTextBorder alloc] init];
    border.fillColor = [UIColor redColor];
    [highlightRange setBorder:border];
    [attributedString pp_setTextHighlightRange:highlightRange];
    
    PPLabel *label = [[PPLabel alloc] init];
    label.attributedString = attributedString;
    label.height = [attributedString pp_sizeConstrainedToWidth:self.view.width].height + 1;
    label.width = self.view.width;
    label.top = 64;
    [self.view addSubview:label];
}


@end
