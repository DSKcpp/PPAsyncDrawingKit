//
//  PPNameLabel.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineScreenNameLabel.h"
#import "WBTimelineItem.h"
#import "NSString+PPAsyncDrawingKit.h"

@implementation WBTimelineScreenNameLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.drawingPolicy = 0;
        self.fontSize = 15;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(self.frame, frame)) {
        [super setFrame:frame];
        [self setNeedsDisplay];
    }
}

- (void)setUser:(WBUser *)user
{
    if (_user != user) {
        _user = user;
        [self setContentsChangedAfterLastAsyncDrawing:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async
{
    NSString *username = self.user.screen_name;
    [username pp_drawInRect:rect withFont:[UIFont systemFontOfSize:self.fontSize] textColor:[UIColor colorWithRed:255/255.0f green:81/255.0f blue:20/255.0f alpha:1.0f] lineBreakMode:NSLineBreakByWordWrapping];
    return YES;
}

- (void)drawingWillStartAsynchronously:(BOOL)async
{
    [self removeRemoteIcons];
}

- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success
{
    if (success) {
        [self addRemoteIcons];
        CGFloat maxX = CGRectGetMaxX(CGRectMake(self.touchableRect.origin.x, self.touchableRect.origin.y, self.currentTextFrame.size.width, self.currentTextFrame.size.height));
        
    }
}

- (void)addRemoteIcons
{
    
}

- (void)removeRemoteIcons
{
    
}

- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent *)event
{
    
}

- (void)_userPressedIcon:(id)arg1
{
    
}

- (void)_userPressedText
{
    
}
@end
