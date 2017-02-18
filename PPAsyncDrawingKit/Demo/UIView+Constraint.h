//
//  UIView+Constraint.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/18.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Constraint)
- (NSLayoutConstraint *)pp_autoLayout:(NSLayoutAttribute)attr1
                              toAttr2:(NSLayoutAttribute)attr2
                               toView:(UIView *)view;

- (NSLayoutConstraint *)pp_autoLayout:(NSLayoutAttribute)attr1
                              toAttr2:(NSLayoutAttribute)attr2
                               toView:(UIView *)view
                               offset:(CGFloat)offset;

- (NSLayoutConstraint *)pp_autoLayoutToSuperView:(NSLayoutAttribute)attr;

- (NSLayoutConstraint *)pp_autoLayoutToSuperView:(NSLayoutAttribute)attr
                                          offset:(CGFloat)offset;

- (NSLayoutConstraint *)pp_autoLayoutautoSetDimension:(NSLayoutAttribute)attr toSize:(CGFloat)size;
@end
