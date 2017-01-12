//
//  WBHelper.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/9.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "WBHelper.h"
#import "YYModel.h"

@implementation WBHelper

@end

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
    name = _config[name];
    if (name.length) {
        return [UIImage imageNamed:name];
    }
    return nil;
}
@end

@implementation WBTimelinePreset
+ (instancetype)sharedInstance
{
    static WBTimelinePreset *_sharedInstance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _leftSpacing = 12.0f;
        _rightSpacing = 12.0f;
        _actionButtonsHeight = 34.0f;
        _titleAreaHeight = 34.0f;
        _titleIconTop = 9.5f;
        _titleIconLeft = 11.0f;
        _titleIconSize = 15.0f;
        _titleFontSize = 14.0f;
        _avatarSize = 39.0f;
        _avatarCornerRadius = 19.5f;
        _avatarTop = 15.0f;
        _nicknameLeft = 62.0f;
        _nicknameTop = 17.0f;
        _nicknameFontSize = 16.0f;
        _gridImageSpacing = 4.0f;
        _gridImageSize = ([UIScreen mainScreen].bounds.size.width - _gridImageSpacing * 2.0f - _leftSpacing * 2.0f) / 3.0f;
        _verticalImageWidth = 148.0f;
        _verticalImageHeight = 196.0f;
        _gridImageTop = 10.0f;
        _gridImageBottom = 12.0f;
        _sourceFontSize = 12.0f;
        _headerAreaHeight = 65.0f;
    }
    return self;
}

@end
