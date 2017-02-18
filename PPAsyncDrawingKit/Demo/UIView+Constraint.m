//
//  UIView+Constraint.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/18.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "UIView+Constraint.h"

@implementation UIView (Constraint)

- (NSLayoutConstraint *)pp_autoLayout:(NSLayoutAttribute)attr1
                              toAttr2:(NSLayoutAttribute)attr2
                               toView:(UIView *)view
{
    return [self pp_autoLayout:attr1 toAttr2:attr2 toView:view offset:0];
}

- (NSLayoutConstraint *)pp_autoLayout:(NSLayoutAttribute)attr1
                              toAttr2:(NSLayoutAttribute)attr2
                               toView:(UIView *)view
                               offset:(CGFloat)offset
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:attr1
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:attr2
                                                                 multiplier:1.0
                                                                   constant:offset];
    constraint.active = YES;
    return constraint;
}

- (NSLayoutConstraint *)pp_autoLayoutToSuperView:(NSLayoutAttribute)attr
{
    return [self pp_autoLayoutToSuperView:attr offset:0];
}

- (NSLayoutConstraint *)pp_autoLayoutToSuperView:(NSLayoutAttribute)attr
                                          offset:(CGFloat)offset
{
    return [self pp_autoLayout:attr toAttr2:attr toView:self.superview offset:offset];
}

- (NSLayoutConstraint *)pp_autoLayoutautoSetDimension:(NSLayoutAttribute)attr toSize:(CGFloat)size
{
    return [self pp_autoLayout:attr toAttr2:NSLayoutAttributeNotAnAttribute toView:nil offset:size];
}
@end
