//
//  WBHelper.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/9.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "WBHelper.h"
#import "YYModel.h"
#import "zlib.h"

@implementation WBHelper
+ (NSURL *)defaultURLForImageURL:(id)imageURL
{
    /*
     微博 API 提供的图片 URL 有时并不能直接用，需要做一些字符串替换：
     http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6.png //input
     http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6_default.png //output
     
     http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_y.png?version=2015080302 //input
     http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_os7.png?version=2015080302 //output
     */
    
    if (!imageURL) return nil;
    NSString *link = nil;
    if ([imageURL isKindOfClass:[NSURL class]]) {
        link = ((NSURL *)imageURL).absoluteString;
    } else if ([imageURL isKindOfClass:[NSString class]]) {
        link = imageURL;
    }
    if (link.length == 0) return nil;
    
    if ([link hasSuffix:@".png"]) {
        // add "_default"
        if (![link hasSuffix:@"_default.png"]) {
            NSString *sub = [link substringToIndex:link.length - 4];
            link = [sub stringByAppendingFormat:@"_default.png"];
        }
    } else {
        // replace "_y.png" with "_os7.png"
        NSRange range = [link rangeOfString:@"_y.png?version"];
        if (range.location != NSNotFound) {
            NSMutableString *mutable = link.mutableCopy;
            [mutable replaceCharactersInRange:NSMakeRange(range.location + 1, 1) withString:@"os7"];
            link = mutable;
        }
    }
    
    return [NSURL URLWithString:link];
}

+ (NSData *)gzipData:(NSData *)pUncompressedData
{
    if (!pUncompressedData || [pUncompressedData length] == 0) {
        NSLog(@"%s: Error: Can't compress an empty or nil NSData object",__func__);
        return nil;
    }
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc = Z_NULL;
    zlibStreamStruct.zfree = Z_NULL;
    zlibStreamStruct.opaque = Z_NULL;
    zlibStreamStruct.total_out = 0;
    zlibStreamStruct.next_in = (Bytef *)[pUncompressedData bytes];
    zlibStreamStruct.avail_in = [pUncompressedData length];
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK) {
        NSString *errorMsg = nil;
        switch (initError) {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s:deflateInit2() Error: \"%@\" Message: \"%s\"",__func__,errorMsg,zlibStreamStruct.msg);
        return nil;
    }
    
    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 21];
    
    int deflateStatus;
    do {
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
    } while (deflateStatus == Z_OK);
    
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus) {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s:zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        deflateEnd(&zlibStreamStruct);
        return nil;
    }
    
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength:zlibStreamStruct.total_out];
    NSLog(@"%s: Compressed file from %d B to %d B", __func__, [pUncompressedData length], [compressedData length]);
    return compressedData;
}

+ (NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    
    unsigned long full_length = [compressedData length];
    
    
    unsigned long half_length = [compressedData length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    
    BOOL done = NO;
    
    int status;
    
    z_stream strm;
    
    strm.next_in = (Bytef *)[compressedData bytes];
    
    strm.avail_in = (uInt)[compressedData length];
    
    strm.total_out = 0;
    
    strm.zalloc = Z_NULL;
    
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    
    while (!done) {
        
        // Make sure we have enough room and reset the lengths.
        
        if (strm.total_out >= [decompressed length]) {
            
            [decompressed increaseLengthBy: half_length];
        }
        
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        
        status = inflate (&strm, Z_SYNC_FLUSH);
        
        if (status == Z_STREAM_END) {
            
            done = YES;
            
        } else if (status != Z_OK) {
            
            break;
        }
        
    }
    
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    
    if (done) {
        
        [decompressed setLength: strm.total_out];
        
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}

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
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        _leftSpacing = 12.0f;
        _rightSpacing = 12.0f;
        _maxWidth = w - _leftSpacing * 2.0f;
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
        _gridImageSize = (_maxWidth - _gridImageSpacing * 2.0f) / 3.0f;
        _verticalImageWidth = 148.0f;
        _verticalImageHeight = 196.0f;
        _gridImageTop = 10.0f;
        _gridImageBottom = 12.0f;
        _sourceFontSize = 12.0f;
        _headerAreaHeight = 65.0f;
        _numberOfLines = 7;
        _defaultMargin = 10.0f;
        _minHeight = 136.0f;
        _pageInfoHeight = 70.0f;
        _textColor = @"333333";
        _subtextColor = @"636363";
        _highlightTextColor = @"507DAE";
        _textBorderColor = @"A7BED6";
        _textFont = 16.0f;
        _subtextFont = 15.0f;
    }
    return self;
}

@end
