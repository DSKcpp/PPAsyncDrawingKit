//
//  PPEditableTextView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/12.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPEditableTextView.h"

static inline NSRange NSRangeFromUITextRange(UITextRange *range) {
    if (range.isEmpty) {
        return NSMakeRange(0, 0);
    }
    return NSMakeRange(range.start, range.end);
}

@implementation PPEditableTextView

- (instancetype)initWithFrame:(CGRect)frame
{
//    UITextView
    if (self = [super initWithFrame:frame]) {
        PPTextView *textView = [[PPTextView alloc] init];
        _textView = textView;
        [self addSubview:_textView];
        
        PPTextSelectionView *selectionView = [[PPTextSelectionView alloc] init];
        _selectionView = selectionView;
        [self addSubview:_selectionView];
    }
    return self;
}

- (NSString *)textInRange:(UITextRange *)range
{
    return [_textView.attributedString.string substringWithRange:NSRangeFromUITextRange(range)];
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{
    [_textView.attributedString replaceCharactersInRange:NSRangeFromUITextRange(range) withString:text];
}

- (void)insertText:(NSString *)text
{
    
}

- (void)deleteBackward
{
    
}

- (void)unmarkText
{
    
}

- (NSInteger)characterOffsetOfPosition:(UITextPosition *)position withinRange:(UITextRange *)range
{
    
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{
    
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other
{
    
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{
    
}

- (UITextPosition *)endOfDocument
{
    
}


- (id<UITextInputTokenizer>)tokenizer
{
    
}

- (UITextPosition *)beginningOfDocument
{
    
}

- (id<UITextInputDelegate>)inputDelegate
{
    
}

- (void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate
{
    
}

- (NSDictionary *)markedTextStyle
{
    
}

- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle
{
    
}

- (UITextRange *)markedTextRange
{
    
}

- (BOOL)hasText
{
    
}

- (UITextRange *)selectedTextRange
{
    
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
    
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
    
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
    
}


- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    
}


- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    
}

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
    
}

- (CGRect)firstRectForRange:(UITextRange *)range
{
    
}

- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    
}

- (UITextPosition *)positionWithinRange:(UITextRange *)range atCharacterOffset:(NSInteger)offset
{
    
}
@end
