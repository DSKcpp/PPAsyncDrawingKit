//
//  WBEmoticonManager.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/3.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBEmoticonManager.h"
#import "YYModel.h"

@interface WBEmoticon : NSObject
@property (nonatomic, copy) NSString *chs;
@property (nonatomic, copy) NSString *png;
@end

@implementation WBEmoticon @end

@interface WBEmoticonConfig : NSObject
@property (nonatomic, strong) NSArray<WBEmoticon *> *emoticons;
@end

@implementation WBEmoticonConfig
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emoticons" : [WBEmoticon class]};
}
@end

@implementation WBEmoticonManager
+ (WBEmoticonManager *)sharedMangaer
{
    static WBEmoticonManager *obj;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emoticon_info" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        WBEmoticonConfig *config = [WBEmoticonConfig yy_modelWithDictionary:dict];
        NSMutableDictionary *configDict = @{}.mutableCopy;
        [config.emoticons enumerateObjectsUsingBlock:^(WBEmoticon * _Nonnull emoticon, NSUInteger idx, BOOL * _Nonnull stop) {
            configDict[emoticon.chs] = emoticon.png;
        }];
        _config = configDict;
    }
    return self;
}

- (UIImage *)imageWithEmotionName:(NSString *)name
{
    return [UIImage imageNamed:_config[name]];
}
@end
