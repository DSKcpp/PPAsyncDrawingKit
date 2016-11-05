//
//  PPAttributedText.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPTextStorage.h"
#import "PPTextParagraphStyle.h"

@interface PPAttributedText : NSObject
+ (id)defaultSchemeForTopicName:(id)arg1;
@property (nonatomic, copy) NSString *plainTextForCharacterCounting;
@property (nonatomic, strong) NSArray *textAttachments;
@property (nonatomic, strong) NSArray *activeRanges;
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
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
@property (nonatomic, copy) NSString *plainText;
@property (nonatomic, strong) UIColor *activeRangeColor;
@property (nonatomic, strong) UIColor *textColor;

- (id)_parseString:(id)arg1 withKeyword:(id)arg2 andCurrentParsingResult:(id)arg3;
- (id)characterCountingPlainTextForTimelineURL:(id)arg1;
- (void)updatePlainTextForCharacterCountingWithAttributedString:(id)arg1;
- (void)updateParagraphStyleForAttributedString:(id)arg1;
- (id)parseActiveRangesFromString:(NSString *)string;
- (id)extractAttachmentsAndMergeToAttributedString:(id)arg1;
- (NSInteger)mergeAttachment:(id)arg1 toAttributedString:(id)arg2 withTextRange:(NSRange)textRange merged:(BOOL)merged;
- (void)insertFlavoredRange:(id)arg1 toMiniCardRange:(id)arg2;
- (id)filterParsingResult:(id)arg1;
- (void)extractAttachmentsAndParseActiveRangesFromParseResult:(id)arg1 toAttributedString:(id)arg2;
- (id)substringOfPageTitle:(id)arg1 withWordCount:(unsigned long long)arg2 trancates:(_Bool *)arg3;
- (id)mutableAttributedString;
- (void)rebuild;
- (void)setColorWithActiveRange:(id)arg1 forAttributedString:(id)arg2;
- (id)attributedStringWithTextColor:(id)arg1;
- (void)wb_paragraphStyleDidUpdateAttribute:(id)arg1;
- (void)wb_textStorage:(id)arg1 didProcessEditing:(unsigned long long)arg2 range:(struct _NSRange)arg3 changeInLength:(long long)arg4;
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
- (instancetype)initWithPlainText:(NSString *)plainText;
- (instancetype)init;

@property(nonatomic) unsigned char textAlignment;
@property(nonatomic) unsigned char lineBreakMode;
@property(nonatomic) double maximunLineHeight;
@property(nonatomic) double lineSpacing;
@property(nonatomic) _Bool allowsDynamicLineSpacing;

@end

@interface PPAttributedText (TextDrawing)
- (CGSize)sizeConstrainedToWidth:(CGFloat)width;
- (CGSize)sizeConstrainedToWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines;
- (CGSize)sizeConstrainedToWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount;
@end

@interface PPAttributedText (CharacterCount)
+ (id)shortenURLReplacementForCharacterCounting:(id)arg1;
@end
