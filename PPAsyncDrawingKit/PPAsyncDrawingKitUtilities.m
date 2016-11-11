//
//  PPAsyncDrawingKitUtilities.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingKitUtilities.h"
#import "PPTextRenderer.h"

@implementation NSObject (PPAsyncDrawingKit)
- (id)pp_objectWithAssociatedKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)pp_setObject:(id)object forAssociatedKey:(void *)key retained:(BOOL)retained
{
    objc_setAssociatedObject(self, key, object, retained ? OBJC_ASSOCIATION_RETAIN_NONATOMIC : OBJC_ASSOCIATION_ASSIGN);
}

- (void)pp_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(self, key, object, policy);
}
@end

@implementation NSMutableDictionary (PPAsyncDrawingKit)
- (void)pp_setSafeObject:(id)object forKey:(NSString *)key
{
    if (object) {
        [self setObject:object forKey:key];
    }
}
@end

@implementation NSCoder (PPAsyncDrawingKit)
- (void)pp_encodeFontMetrics:(PPFontMetrics)fontMetrics forKey:(nonnull NSString *)key
{
    [self encodeCGRect:CGRectMake(fontMetrics.ascent, fontMetrics.descent, fontMetrics.leading, 0) forKey:key];
}

- (PPFontMetrics)pp_decodeFontMetricsForKey:(NSString *)key
{
    CGRect rect = [self decodeCGRectForKey:key];
    PPFontMetrics fontMetrics;
    fontMetrics.ascent = rect.origin.x;
    fontMetrics.descent = rect.origin.y;
    fontMetrics.leading = rect.size.width;
    return fontMetrics;
}
@end
