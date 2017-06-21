//
//  AsyncTextView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/11.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncTextView: AsyncDrawingView {
    
    public var attributedString: NSAttributedString? {
        get {
            return textLayout.attributedString
        } set {
            textLayout.attributedString = newValue
            setNeedsDisplay()
        }
    }
    
    public lazy var textLayout: AsyncTextLayout = {
        let textLayout = AsyncTextLayout(attributedString: nil)
        return textLayout
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        clearsContextBeforeDrawing = false
        contentMode = .redraw
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textLayout.textRenderer.touchesBegan(touches, with: event)
        if textLayout.textRenderer.pressingHighlight == nil {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        textLayout.textRenderer.touchesMoved(touches, with: event)
        if textLayout.textRenderer.pressingHighlight == nil {
            super.touchesMoved(touches, with: event)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textLayout.textRenderer.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        textLayout.textRenderer.touchesCancelled(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
    
    override func draw(_ rect: CGRect, in ctx: CGContext, async: Bool) -> Bool {
        guard let _ = attributedString else { return false }
        textLayout.textRenderer.drawInContext(ctx, visibleRect: rect, placeAttachments: true)
        return true
    }
    
//    
//    - (void)setTextLayout:(PPTextLayout *)textLayout
//    {
//    if (_textLayout == textLayout) {
//    return;
//    }
//    
//    _textLayout = textLayout;
//    _textLayout.textRenderer.eventDelegate = self;
//    }
//    

//    - (CGSize)sizeThatFits:(CGSize)size
//    {
//    if (self.attributedString) {
//    return [self.attributedString pp_sizeConstrainedToSize:size numberOfLines:self.textLayout.numberOfLines];
//    } else {
//    return size;
//    }
//    }
//    
//    - (PPAsyncDrawingView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer
//    {
//    return self;
//    }
//    
//    - (void)textRenderer:(PPTextRenderer *)textRenderer pressedTextHighlightRange:(nonnull PPTextHighlightRange *)highlightRange
//    {
//    if ([_delegate respondsToSelector:@selector(textLayout:pressedTextHighlightRange:)]) {
//    [_delegate textLayout:self.textLayout pressedTextHighlightRange:highlightRange];
//    }
//    }
//    
//    - (void)textRenderer:(PPTextRenderer *)textRenderer pressedTextBackground:(nonnull PPTextBackground *)background
//    {
//    if ([_delegate respondsToSelector:@selector(textLayout:pressedTextBackground:)]) {
//    [_delegate textLayout:self.textLayout pressedTextBackground:background];
//    }
//    }

}
