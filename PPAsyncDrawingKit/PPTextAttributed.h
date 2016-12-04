//
//  PPTextAttributed.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPTextStorage.h"
#import "PPTextParagraphStyle.h"
#import "PPTextActiveRange.h"

@class PPTextAttachment;

NS_ASSUME_NONNULL_BEGIN

@protocol PPTextParser <NSObject>
- (nullable NSArray<PPTextActiveRange *> *)parserWithString:(nullable NSString *)string;

@optional
- (nullable NSArray<PPTextActiveRange *> *)extractAttachmentsAndParseActiveRangesFromParseResult:(nullable NSArray<PPTextActiveRange *> *)parseResult toAttributedString:(NSMutableAttributedString *)attributedString ;
@end

@interface PPTextAttributed : NSObject
@property (nonatomic, strong) id<PPTextParser> textParser;
@property (nonatomic, copy) NSString *plainTextForCharacterCounting;
@property (nullable, nonatomic, strong) NSArray<PPTextAttachment *> *textAttachments;
@property (nullable, nonatomic, strong) NSArray<PPTextActiveRange *> *activeRanges;
@property (nullable, nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, assign) BOOL shouldShowSmallCardForcily;
@property (nonatomic, strong) NSDictionary *analysisParameters;
@property (nonatomic, strong) NSArray *userActiveRanges;
@property (nonatomic, strong) NSString *activeRangeColorKey;
@property (nonatomic, strong) NSString *textColorKey;
@property (nonatomic, strong) NSDictionary *titleInfos;
@property (nonatomic, strong) NSArray *topicItems;
@property (nonatomic, strong) NSArray *keywords;
@property (nonatomic, strong, readonly) NSArray *urlItems;
@property (nonatomic, assign) BOOL smallSizeEmoticons;
@property (nonatomic, assign) NSUInteger textLigature;
@property (nonatomic, assign) NSInteger linkUnderlineStyle;
@property (nonatomic, assign) NSInteger parseOptions;
@property (nonatomic, strong) PPTextParagraphStyle *paragraphStyle;
@property (nonatomic, assign) BOOL boldFont;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) PPTextStorage *textStorage;
@property (nonatomic, copy, readonly) NSString *plainText;
@property (nonatomic, strong) UIColor *activeRangeColor;
@property (nonatomic, strong) UIColor *textColor;

- (instancetype)initWithPlainText:(NSString *)plainText;
- (id)characterCountingPlainTextForTimelineURL:(id)arg1;
- (void)updatePlainTextForCharacterCountingWithAttributedString:(NSMutableAttributedString *)attributedString;
- (void)updateParagraphStyleForAttributedString:(NSMutableAttributedString *)attributedString;
- (id)extractAttachmentsAndMergeToAttributedString:(id)arg1;
- (NSInteger)mergeAttachment:(PPTextAttachment *)attachment toAttributedString:(NSMutableAttributedString *)attributedString withTextRange:(NSRange)textRange merged:(BOOL)merged;
- (void)insertFlavoredRange:(id)arg1 toMiniCardRange:(id)arg2;
- (NSArray<PPTextActiveRange *> *)filterParsingResult:(NSArray<PPTextActiveRange *> *)result;
- (id)substringOfPageTitle:(id)arg1 withWordCount:(unsigned long long)arg2 trancates:(BOOL)arg3;
- (nullable NSMutableAttributedString *)mutableAttributedString;
- (void)rebuild;
- (void)setColorWithActiveRange:(PPTextActiveRange *)activeRange forAttributedString:(NSMutableAttributedString *)attributedString;
- (id)attributedStringWithTextColor:(id)arg1;
- (void)PP_paragraphStyleDidUpdateAttribute:(id)arg1;
- (BOOL)isTrancationed;
- (BOOL)replaceEndingCharWithString:(id)arg1 andUrl:(id)arg2 inWidth:(double)arg3 andLineLimited:(NSUInteger)arg4 andActualLineDisplayed:(NSUInteger)arg5;
- (BOOL)isTrancationedWithSurfix:(id)arg1 contentStr:(id)arg2 andUrl:(id)arg3 inWidth:(double)arg4 andLimitedLine:(NSUInteger)arg5;
- (BOOL)trancationTextWithLineWidth:(CGFloat)width andLineLimited:(NSUInteger)arg2 andActualLineDisplayed:(NSUInteger)arg3;
- (id)timelineURLForTitle:(id)arg1;
- (id)timelineURLForScheme:(id)arg1;
- (id)schemeForMiniCardActiveRange:(id)arg1;
- (id)schemeForTitleName:(id)arg1;
- (id)schemeForTopicName:(id)arg1;
- (id)accessibilityPlainText;
- (NSRange)attributedStringRangeForPlainTextRange:(NSRange)range;
- (NSRange)plainTextRangeForAttributedStringRange:(NSRange)range;
- (id)textAttachmentsInRange:(NSRange)range;
- (void)resetTextStorageWithPlainText:(NSString *)plainText;
- (void)rebuildIfNeeded;
- (void)setNeedsRebuild;

@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, assign) CGFloat maximunLineHeight;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) BOOL allowsDynamicLineSpacing;
@end

@interface PPTextAttributed (TextDrawing)
- (CGSize)sizeConstrainedToWidth:(CGFloat)width;
- (CGSize)sizeConstrainedToWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines;
- (CGSize)sizeConstrainedToWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount;
@end

@interface PPTextAttributed (CharacterCount)
+ (id)shortenURLReplacementForCharacterCounting:(id)arg1;
@end

NS_ASSUME_NONNULL_END
