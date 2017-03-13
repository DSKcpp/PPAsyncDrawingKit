//
//  PPTextAttributedExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/9.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTextAttributedExample.h"
#import "UIView+Frame.h"
#import "PPTextView.h"

@interface PPTextAttributedExample () <PPTextEventDelegate>

@end

@implementation PPTextAttributedExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Highligh Background"];
        [attributedString pp_setFont:[UIFont boldSystemFontOfSize:30.0f]];
        [attributedString pp_setAlignment:NSTextAlignmentCenter];
        
        PPTextView *label = [[PPTextView  alloc] init];
        label.attributedString = attributedString;
        
        PPTextBackground *background = [[PPTextBackground alloc] init];
        background.backgroundColor = [UIColor orangeColor];
        label.textLayout.highlighttextBackground = background;
        
        label.frame = CGRectMake(0, 164, self.view.width, [attributedString pp_sizeConstrainedToWidth:self.view.width].height);
        [self.view addSubview:label];
    }
    
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"@DSKcpp: A you ok?"];
        [attributedString pp_setFont:[UIFont boldSystemFontOfSize:30.0f]];
        [attributedString pp_setColor:[UIColor purpleColor] inRange:NSMakeRange(0, 7)];
        [attributedString pp_setAlignment:NSTextAlignmentCenter];
        
        PPTextHighlightRange *highlightRange = [[PPTextHighlightRange alloc] init];
        highlightRange.userInfo = @{@"key" : @"@DSKcpp"};
        PPTextBorder *border = [[PPTextBorder alloc] init];
        border.fillColor = [UIColor redColor];
        [highlightRange setBorder:border];
        [attributedString pp_setTextHighlightRange:highlightRange inRange:NSMakeRange(0, 7)];
        
        PPTextView *label = [[PPTextView  alloc] init];
        label.attributedString = attributedString;
        label.delegate = self;
        label.frame = CGRectMake(0, 264, self.view.width, [attributedString pp_sizeConstrainedToWidth:self.view.width].height);
        [self.view addSubview:label];
    }
}

- (void)textLayout:(PPTextLayout *)textLayout pressedTextHighlightRange:(nonnull PPTextHighlightRange *)highlightRange
{
    NSString *value = highlightRange.userInfo[@"key"];
    NSLog(@"%@", value);
}

- (void)textLayout:(PPTextLayout *)textLayout pressedTextBackground:(PPTextBackground *)background
{
    
}

@end
