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
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"Highligh"];
        [attrStr pp_setFont:[UIFont boldSystemFontOfSize:30.0f]];
        PPTextHighlightRange *highlightRange = [[PPTextHighlightRange alloc] init];
        PPTextBorder *border = [[PPTextBorder alloc] init];
        border.fillColor = [UIColor redColor];
        [highlightRange setBorder:border];
        [attrStr pp_setTextHighlightRange:highlightRange];
        [attributedString appendAttributedString:attrStr];
        [attributedString appendAttributedString:[self padding]];
    }
    
    {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"Highligh"];
        [attrStr pp_setFont:[UIFont boldSystemFontOfSize:30.0f]];
        PPTextHighlightRange *highlightRange = [[PPTextHighlightRange alloc] init];
        PPTextBorder *border = [[PPTextBorder alloc] init];
        border.fillColor = [UIColor redColor];
        [highlightRange setBorder:border];
        [attrStr pp_setTextHighlightRange:highlightRange];
        [attributedString appendAttributedString:attrStr];
    }
    
    PPLabel *label = [[PPLabel  alloc] init];
    label.attributedString = attributedString;
    [attributedString pp_setAlignment:NSTextAlignmentCenter];
    label.height = [attributedString pp_sizeConstrainedToWidth:self.view.width].height + 1;
    label.width = self.view.width;
    label.top = 64;
    [self.view addSubview:label];
}

- (NSAttributedString *)padding
{
    NSMutableAttributedString *pad = [[NSMutableAttributedString alloc] initWithString:@"\n\n"];
    [pad pp_setFont:[UIFont systemFontOfSize:4]];
    return pad;
}
@end
