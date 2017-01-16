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

@interface PPEditableTextView () <UIScrollViewDelegate>
{
    NSRange _savedSelectionRange;
}
@property (nonatomic, strong) PPTextRange *selection;
@property (nonatomic, strong) PPTextUndoManager *undoManager;
@end

@implementation PPEditableTextView
@synthesize tokenizer = _tokenizer;
@synthesize inputDelegate = _inputDelegate;
@synthesize markedTextStyle = _markedTextStyle;
@synthesize markedTextRange = _markedTextRange;
@synthesize undoManager = _undoManager;
@synthesize selectionAffinity = _selectionAffinity;

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;
@synthesize spellCheckingType = _spellCheckingType;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize secureTextEntry = _secureTextEntry;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [super setDelegate:self];
        
        _tokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
        
        PPTextView *textView = [[PPTextView alloc] init];
        _textView = textView;
        _textView.frame = frame;
        [self addSubview:_textView];
        
        PPTextSelectionView *selectionView = [[PPTextSelectionView alloc] init];
        _selectionView = selectionView;
        [self addSubview:_selectionView];
        
        _editable = YES;
        
        _autocapitalizationType = UITextAutocapitalizationTypeSentences;
        _autocorrectionType = UITextAutocorrectionTypeDefault;
        _spellCheckingType = UITextSpellCheckingTypeDefault;
        _returnKeyType = UIReturnKeyDefault;
        _enablesReturnKeyAutomatically = NO;
        _secureTextEntry = NO;
    }
    return self;
}

- (NSUInteger)contentLength
{
    return _textView.attributedString.length;
}

- (NSAttributedString *)attributedString
{
    return _textView.attributedString;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _textView.attributedString = attributedString;
}

- (NSUndoManager *)undoManager
{
    if (!_undoManager) {
        _undoManager = [[PPTextUndoManager alloc] init];
    }
    return _undoManager;
}


- (NSRange)_selectionRange
{
    NSRange _range;
    if (!self.isEditing) {
        _range = _savedSelectionRange;
    } else {
        if (_selection) {
            _range = _selection.range;
        }
    }
    return _range;
}

//- (NSRange)_rangeToReplace
//{
//    if (!self.isEditing) {
//        return _savedSelectionRange;
//    } else {
//        if (_markedTextRange) {
//            return _markedTextRange;
//        } else {
//        }
//    }
//}

- (BOOL)resignFirstResponder
{
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    BOOL become = [super becomeFirstResponder];
    return become;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [super touchesEnded:touches withEvent:event];
    [self becomeFirstResponder];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - manipulating text
- (NSString *)textInRange:(UITextRange *)range
{
    if ([range isKindOfClass:[PPTextRange class]]) {
        PPTextRange *_range = (PPTextRange *)range;
        return [self _plainTextInRangeForTextInput:_range.range];
    } else {
        return nil;
    }
}

- (NSString *)_plainTextInRangeForTextInput:(NSRange)range
{
    NSString *text = [self.attributedString.string substringWithRange:range];
    return [text stringByReplacingOccurrencesOfString:text withString:@""];
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{
    if (!text.length) {
        text = @"";
    }
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text];
    [self replaceRange:range withAttributedText:attributedString];
}

- (void)replaceRange:(UITextRange *)range withAttributedText:(NSAttributedString *)attributedText
{
    if (![range isKindOfClass:[PPTextRange class]]) {
        return;
    }
    PPTextRange *textRange = (PPTextRange *)range;
    NSUInteger start = textRange.start.index;
    NSUInteger end = textRange.end.index;
    if (end <= start) {
        return;
    }
}

- (NSUInteger)_replaceTextInRange:(NSRange)range withText:(NSString *)text
{
    return range.location + text.length;
}

- (BOOL)_shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![self.delegate respondsToSelector:@selector(editableTextView:shouldChangeTextInRange:replacementText:)]) {
        return NO;
    }
    
    BOOL shouldChange = [self.delegate editableTextView:self shouldChangeTextInRange:range replacementText:text];
    if (range.length > 0 && text.length == 0) {
        
    }
    return shouldChange;
}

#pragma mark - UIKeyInput
- (BOOL)hasText
{
    return self.attributedString.string.length > 0;
}

- (void)insertText:(NSString *)text
{
    if (!self.isEditable || text.length == 0) {
        return;
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text];
    [self insertAttributedText:attributedString];
}

- (void)insertAttributedText:(NSAttributedString *)attributedText
{
    if (!self.isEditable) {
        return;
    }
    
    if (self.returnKeyType != UIReturnKeyDefault && [attributedText.string isEqualToString:@"\n"]) {
        [self endEditing:YES];
    } else {
//        NSRange range = [self _rangeToReplace];
//        if (range.location + range.length <= self.contentLength) {
            [self.undoManager willBeginUndoRegistrationWithType:0];
        NSRange r = NSMakeRange(self.contentLength, self.contentLength);
            PPTextRange *textRange = [[PPTextRange alloc] initWithRange:r];
            [self replaceRange:textRange withAttributedText:attributedText];
            [self.undoManager setActionName:@""];
            [self.undoManager didFinishUndoRegistration];
//        }
    }
}

- (void)deleteBackward
{
    if (!self.isEditable) {
        return;
    }
}

- (void)unmarkText
{
//    [self.undoManager undo];
}

#pragma mark - Hit Test
- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
    return [self selectionRangeForPoint:point granularity:UITextGranularityCharacter];
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    return [self closestPositionToPoint:point withinRange:nil];
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
    NSUInteger index = [self textIndexForPoint:point];
    if (index == -1) {
        return nil;
    } else {
        if (range) {
            index = ((PPTextRange *)range).range.location;
        }
        return [[PPTextPosition alloc] initWithIndex:index];
    }
}

- (PPTextRange *)selectionRangeForPoint:(CGPoint)point granularity:(UITextGranularity)granularity
{
    NSUInteger index = [self textIndexForPoint:point];
    PPTextPosition *position = [PPTextPosition postionWithIndex:index];
    return [self selectionRangeForPosition:position granularity:granularity];
}

- (PPTextRange *)selectionRangeForPosition:(PPTextPosition *)position granularity:(UITextGranularity)granularity
{
//    if (position.index == -1) {
//
//    }
    
    return [_tokenizer rangeEnclosingPosition:position withGranularity:granularity inDirection:UITextStorageDirectionForward];
}

- (NSUInteger)textIndexForPoint:(CGPoint)point
{
    NSRange range = NSMakeRange(0, self.attributedString.length);
    [_textView.textRenderer enumerateLineFragmentsForCharacterRange:range usingBlock:^(CGRect rect, NSRange range, BOOL * _Nonnull stop) {
        
    }];
//    _textView.textRenderer lineFragmentRectForLineAtIndex:<#(NSUInteger)#> effectiveRange:<#(nullable NSRangePointer)#>
    return 0;
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{
    
}

#pragma mark - Layout questions
- (PPTextPosition *)positionWithinRange:(PPTextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
    
    PPTextPosition *position = [self positionFromPosition:range.start inDirection:direction offset:0];
    return position;
}

- (PPTextRange *)characterRangeByExtendingPosition:(PPTextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    PPTextPosition *_position = [self positionFromPosition:position inDirection:direction offset:0];
    NSUInteger index = _position.index;
    if (position.index <= index) {
        
    } else {
        
    }
    return [[PPTextRange alloc] initWithStart:position end:_position];
}

#pragma mark - Simple evaluation of positions
- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition
{
    if (!from) {
        return 0;
    }
    return 0;
}

- (NSComparisonResult)comparePosition:(PPTextPosition *)position toPosition:(PPTextPosition *)other
{
    if (position && other) {
        return [position compare:other];
    }
    return 0;
}

#pragma mark - The end and beginning of the the text document
- (UITextPosition *)beginningOfDocument
{
    return [[PPTextPosition alloc] initWithIndex:0];
}


- (UITextPosition *)endOfDocument
{
    NSUInteger end = self.attributedString.length;
    return [[PPTextPosition alloc] initWithIndex:end];
}

- (id<UITextInputDelegate>)inputDelegate
{
    return _inputDelegate;
}

- (void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate
{
    _inputDelegate = inputDelegate;
}


- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle
{
    _markedTextStyle = markedTextStyle;
}

- (UITextRange *)markedTextRange
{
//    if (self.markedRange.length) {
//        return [[PPTextRange alloc] initWithRange:self.markedRange];
//    }
    return nil;
}

- (NSDictionary *)markedTextStyle
{
    return _markedTextStyle;
}

- (UITextRange *)selectedTextRange
{
    return self.selection;
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
    PPTextRange *_textRange = (PPTextRange *)selectedTextRange;
    if (_textRange) {
        if (_textRange.range.length) {
            self.selection = _textRange;
            return;
        }
        [self _textSelectionWillChange];
    } else {
        [self _textSelectionWillChange];
    }
    [self setSelectionRange:_textRange.range showsGrabber:YES];
    [self _textSelectionDidChange];
}

- (void)setSelectionRange:(NSRange)range showsGrabber:(BOOL)showsGrabber
{
    
}

#pragma mark - Geometry used to provide, for example, a correction rect
- (CGRect)firstRectForRange:(UITextRange *)range
{
    NSArray *selectionRects = [self selectionRectsForRange:range];
    if (selectionRects.count > 0) {
        return [selectionRects.firstObject CGRectValue];
    }
    return CGRectZero;
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    return @[];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

- (CGRect)caretRectForSelectionIndex:(NSUInteger)index
{
    return [self caretRectForSelectionIndex:index selectionAffinity:_selectionAffinity];
}

- (CGRect)caretRectForSelectionIndex:(NSUInteger)index selectionAffinity:(UITextStorageDirection)selectionAffinity
{
    return CGRectZero;
}

#pragma mark - Creating ranges and positions
- (PPTextRange *)textRangeFromPosition:(PPTextPosition *)fromPosition toPosition:(PPTextPosition *)toPosition
{
    return [[PPTextRange alloc] initWithStart:fromPosition end:toPosition];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
    return [self positionFromPosition:position inDirection:UITextLayoutDirectionLeft offset:offset];
}

- (PPTextPosition *)positionFromPosition:(PPTextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    return position;
}

#pragma mark - Writing direction
- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    return UITextWritingDirectionLeftToRight;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{
    return;
}

- (void)_textSelectionWillChange
{
    [_inputDelegate selectionWillChange:self];
}

- (void)_textSelectionDidChange
{
    [_inputDelegate selectionDidChange:self];
}

- (void)_textContentWillChange
{
    [_inputDelegate textWillChange:self];
}

- (void)_textContentDidChange
{
    [_inputDelegate textDidChange:self];
}

@end
