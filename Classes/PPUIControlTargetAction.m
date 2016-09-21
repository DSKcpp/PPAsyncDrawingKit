//
//  PPUIControlTargetAction.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/22.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPUIControlTargetAction.h"

@implementation PPUIControlTargetAction

- (BOOL)isEqual:(id)object
{
    if (object != self) {
        if ([object isKindOfClass:[self class]]) {
            PPUIControlTargetAction *obj = (PPUIControlTargetAction *)object;
            if (obj.target != self.target) {
                return NO;
            } else {
                if (obj.action == self.action && obj.controlEvents == self.controlEvents) {
                    return YES;
                } else {
                    return NO;
                }
            }
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}
@end
