//
//  PPEditableTextView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/12.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <PPAsyncDrawingKit/PPAsyncDrawingView.h>
#import <PPAsyncDrawingKit/PPTextView.h>
#import <PPAsyncDrawingKit/PPTextSelectionView.h>

@class PPEditableTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol PPEditableTextViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (BOOL)editableTextViewShouldBeginEditing:(PPEditableTextView *)editableTextView;
- (BOOL)textViewShouldEndEditing:(PPEditableTextView *)editableTextView;

- (void)editableTextViewDidBeginEditing:(PPEditableTextView *)editableTextView;
- (void)editableTextViewDidEndEditing:(PPEditableTextView *)editableTextView;

- (BOOL)editableTextView:(PPEditableTextView *)editableTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)editableTextViewDidChange:(PPEditableTextView *)editableTextView;

- (void)editableTextViewDidChangeSelection:(PPEditableTextView *)editableTextView;

@end

@interface PPEditableTextView : UIScrollView //<UITextInput>
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong, readonly) PPTextView *textView;
@property (nonatomic, strong, readonly) PPTextSelectionView *selectionView;
@property (nonatomic, assign, getter=isEditable) BOOL editable;
@property (nonatomic, assign, getter=isEditing) BOOL editing;
@property (nonatomic, weak) id<UITextInputDelegate> inputDelegate;
@property (nonatomic, readonly) id<UITextInputTokenizer> tokenizer;

- (instancetype)initWithFrame:(CGRect)frame;
@property (nullable, nonatomic, weak) id<PPEditableTextViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
