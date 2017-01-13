//
//  PPEditableTextView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/12.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPEditableTextView.h"
#import "PPTextRange.h"
#import "PPTextUndoManager.h"

//@interface PPEditableTextView ()
//{
//    NSUInteger _contentLength;
//}
//@property (nonatomic, strong) PPTextRange *selection;
//@property (nonatomic, assign) NSRange markedRange;
//@property (nonatomic, strong) PPTextUndoManager *undoManager;
//@end
//
@implementation PPEditableTextView
@end
//@synthesize tokenizer = _tokenizer;
//@synthesize inputDelegate = _inputDelegate;
//@synthesize markedTextStyle = _markedTextStyle;
//@synthesize undoManager = _undoManager;
//@dynamic delegate;
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        PPTextView *textView = [[PPTextView alloc] init];
//        _textView = textView;
//        [self addSubview:_textView];
//        
//        PPTextSelectionView *selectionView = [[PPTextSelectionView alloc] init];
//        _selectionView = selectionView;
//        [self addSubview:_selectionView];
//    }
//    return self;
//}
//
//- (NSAttributedString *)attributedString
//{
//    return _textView.attributedString;
//}
//
//- (void)setAttributedString:(NSAttributedString *)attributedString
//{
//    _textView.attributedString = attributedString;
//}
//
//- (NSUndoManager *)undoManager
//{
//    if (!_undoManager) {
//        _undoManager = [[PPTextUndoManager alloc] init];
//    }
//    return _undoManager;
//}
//
//
//- (NSRange)_selectionRange
//{
//    
//}
//
//- (NSRange)_rangeToReplace
//{
//    if (!self.isEditing) {
//        return NSMakeRange(0, 0);
//    }
//}
//
//#pragma mark - manipulating text
//- (NSString *)textInRange:(UITextRange *)range
//{
//    if ([range isKindOfClass:[PPTextRange class]]) {
//        PPTextRange *_range = (PPTextRange *)range;
//        return [self _plainTextInRangeForTextInput:_range.range];
//    } else {
//        return nil;
//    }
//}
//
//- (NSString *)_plainTextInRangeForTextInput:(NSRange)range
//{
//    NSString *text = [self.attributedString.string substringWithRange:range];
//    return [text stringByReplacingOccurrencesOfString:text withString:@""];
//}
//
//- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
//{
//    if (!text.length) {
//        text = @"";
//    }
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text];
//    [self replaceRange:range withAttributedText:attributedString];
//}
//
//- (void)replaceRange:(UITextRange *)range withAttributedText:(NSAttributedString *)attributedText
//{
//    if (![range isKindOfClass:[PPTextRange class]]) {
//        return;
//    }
//    PPTextRange *textRange = (PPTextRange *)range;
//    NSUInteger start = textRange.start.index;
//    NSUInteger end = textRange.end.index;
//    if (end <= start) {
//        return;
//    }
//}
//
//- (NSUInteger)_replaceTextInRange:(NSRange)range withText:(NSString *)text
//{
//    return range.location + text.length;
//}
//
//- (BOOL)_shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (![self.delegate respondsToSelector:@selector(editableTextView:shouldChangeTextInRange:replacementText:)]) {
//        return NO;
//    }
//    
//    BOOL shouldChange = [self.delegate editableTextView:self shouldChangeTextInRange:range replacementText:text];
//    if (range.length > 0 && text.length == 0) {
//        
//    }
//    return shouldChange;
//}
//
//#pragma mark - UIKeyInput
//- (BOOL)hasText
//{
//    return self.attributedString.string.length > 0;
//}
//
//- (void)insertText:(NSString *)text
//{
//    if (!self.isEditable) {
//        return;
//    }
//    
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text];
//    [self insertAttributedText:attributedString];
//}
//
//- (void)insertAttributedText:(NSAttributedString *)attributedText
//{
//    if (!self.isEditable) {
//        return;
//    }
//    
//    if (self.returnKeyType != UIReturnKeyDefault && [attributedText.string isEqualToString:@"\n"]) {
//        [self endEditing:YES];
//    } else {
//        
//    }
//}
//
//- (void)deleteBackward
//{
//    if (!self.isEditable) {
//        return;
//    }
//    
//    
//}
//
//- (void)unmarkText
//{
////    [self.undoManager undo];
//}
//
//#pragma mark - Hit Test
//- (UITextRange *)characterRangeAtPoint:(CGPoint)point
//{
//    return [self selectionRangeForPoint:point granularity:0];
//}
//
//- (UITextPosition *)closestPositionToPoint:(CGPoint)point
//{
//    
//}
//
//- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
//{
//    
//}
//
//- (PPTextRange *)selectionRangeForPoint:(CGPoint)point granularity:(NSInteger)granularity
//{
//    
//}
//
//- (NSUInteger)textIndexForPoint:(CGPoint)point
//{
//    NSRange range = NSMakeRange(0, self.attributedString.length);
//    [_textView.textRenderer enumerateLineFragmentsForCharacterRange:range usingBlock:^(CGRect rect, NSRange range, BOOL * _Nonnull stop) {
//        
//    }];
//    _textView.textRenderer lineFragmentRectForLineAtIndex:<#(NSUInteger)#> effectiveRange:<#(nullable NSRangePointer)#>
//}
//
//- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
//{
//    
//}
//
//- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other
//{
//    
//}
//
//- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction
//{
//    
//}
//
//- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction
//{
//    
//}
//
//- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition
//{
//    
//}
//
//#pragma mark - The end and beginning of the the text document
//- (UITextPosition *)beginningOfDocument
//{
//    return [[PPTextPosition alloc] initWithIndex:0];
//}
//
//
//- (UITextPosition *)endOfDocument
//{
//    NSUInteger end = self.attributedString.length;
//    return [[PPTextPosition alloc] initWithIndex:end];
//}
//
//- (id<UITextInputTokenizer>)tokenizer
//{
//    if (_tokenizer) {
//        _tokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
//    }
//    return _tokenizer;
//}
//
//- (id<UITextInputDelegate>)inputDelegate
//{
//    return _inputDelegate;
//}
//
//- (void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate
//{
//    _inputDelegate = inputDelegate;
//}
//
//
//
//- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle
//{
//    
//}
//
//- (UITextRange *)markedTextRange
//{
//    if (self.markedRange.length) {
//        return [[PPTextRange alloc] initWithRange:self.markedRange];
//    }
//    return nil;
//}
//
//- (NSDictionary *)markedTextStyle
//{
//    return _markedTextStyle;
//}
//
//- (UITextRange *)selectedTextRange
//{
//    return self.selection;
//}
//
//- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
//{
//    PPTextRange *_textRange = (PPTextRange *)selectedTextRange;
//    if (_textRange) {
//        if (_textRange.range.length) {
//            self.selection = _textRange;
//            return;
//        }
//        [self _textSelectionWillChange];
//    } else {
//        [self _textSelectionWillChange];
//    }
//    [self setSelectionRange:_textRange.range showsGrabber:YES];
//    [self _textSelectionDidChange];
//}
//
//- (void)setSelectionRange:(NSRange)range showsGrabber:(BOOL)showsGrabber
//{
//    
//}
//
//#pragma mark - Geometry used to provide, for example, a correction rect
//- (CGRect)firstRectForRange:(UITextRange *)range
//{
//    
//}
//
//- (NSArray *)selectionRectsForRange:(UITextRange *)range
//{
//    
//}
//
//- (CGRect)caretRectForPosition:(UITextPosition *)position
//{
//    
//}
//
//#pragma mark - Creating ranges and positions
//- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
//{
//    
//}
//
//- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
//{
//    return [self positionFromPosition:position inDirection:UITextLayoutDirectionLeft offset:offset];
//}
//
//- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
//{
//    
//}
//
//#pragma mark - Writing direction
//- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
//{
//    return UITextWritingDirectionLeftToRight;
//}
//
//- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
//{
//    return;
//}
//
//- (void)_textSelectionWillChange
//{
//    [_inputDelegate selectionWillChange:self];
//}
//
//- (void)_textSelectionDidChange
//{
//    [_inputDelegate selectionDidChange:self];
//}
//
//- (void)_textContentWillChange
//{
//    [_inputDelegate textWillChange:self];
//}
//
//- (void)_textContentDidChange
//{
//    [_inputDelegate textDidChange:self];
//}
//
//@end
