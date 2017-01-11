//
//  PPAsyncDrawingKitUtilities.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (PPAsyncDrawingKit)
- (nullable id)pp_objectWithAssociatedKey:(void * __nonnull)key;
- (void)pp_setObject:(id)object forAssociatedKey:(void *)key retained:(BOOL)retained;
- (void)pp_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy;
@end

@interface NSMutableDictionary (PPAsyncDrawingKit)
- (void)pp_setSafeObject:(id)object forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
