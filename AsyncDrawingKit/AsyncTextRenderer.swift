//
//  AsyncTextRenderer.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/14.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

protocol AsyncTextRendererEventDelegate: NSObjectProtocol {
    
    func contextViewForTextRenderer(_ textRenderer: AsyncTextRenderer) -> AsyncDrawingView?
    
//    func textRenderer(_ textRenderer: AsyncTextRenderer, didPressTextHighlightRange:)
//    pressedTextBackground
}

public final class AsyncTextRenderer: UIResponder {
    
    var textLayout: AsyncTextLayout!
    weak var delegate: AsyncTextRendererEventDelegate?
    var pressingHighlight: AsyncTextHighlight?
    
    public static var debugModeEnabled = false
    
    var frame: CGRect {
        return textLayout?.frame ?? .zero
    }
    
    var drawingOrigin: CGPoint {
        return textLayout?.drawOrigin ?? .zero
    }
    
    init(textLayout: AsyncTextLayout) {
        self.textLayout = textLayout
    }
}

extension AsyncTextRenderer {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchView = delegate?.contextViewForTextRenderer(self) else { return }
        let touches = event?.touches(for: touchView)
        var point = CGPoint.zero
        if let touch = touches?.first {
            point = touch.location(in: touchView)
        }
        point = convertPointToLayout(point)
        if let high = highlightRangeForLayoutLocation(point) {
            pressingHighlight = high
            touchView.setNeedsDisplayMainThread()
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}


//#pragma mark - Event
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    PPAsyncDrawingView *touchView = self.eventDelegateContextView;
//    if (!touchView) {
//        return;
//    }
//    
//    NSSet<UITouch *> * _touches = [event touchesForView:touchView];
//    UITouch *touch = _touches.anyObject;
//    CGPoint point = CGPointZero;
//    if (touch) {
//        point = [touch locationInView:touchView];
//    }
//    point = [self convertPointToLayout:point];
//    PPTextHighlightRange *range = [self highlightRangeForLayoutLocation:point];
//    if (range) {
//        self.pressingHighlightRange = range;
//        [touchView setNeedsDisplayMainThread];
//    } else if (self.textLayout.highlighttextBackground) {
//        self.highlight = YES;
//        [touchView setNeedsDisplayMainThread];
//    }
//    _touchesBeginPoint = point;
//    }
//    
//    - (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    PPAsyncDrawingView *touchView = self.eventDelegateContextView;
//    UITouch *touch = touches.anyObject;
//    CGPoint point = CGPointZero;
//    if (touch) {
//        point = [touch locationInView:touchView];
//    }
//    //    CGPoint touchesBeginPoint = _touchesBeginPoint;
//    
//    BOOL touchInside = YES;
//    //    CGFloat left = touchView.bounds.size.width - touchesBeginPoint.x;
//    //    if (point.x > touchesBeginPoint.x) {
//    //        touchInside = NO;
//    //    }
//    if (!touchInside) {
//        PPTextHighlightRange *r = _pressingHighlightRange;
//        if (r) {
//            _pressingHighlightRange = nil;
//            _savedPressingHighlightRange = r;
//            [touchView setNeedsDisplayMainThread];
//        }
//    } else {
//        if (_savedPressingHighlightRange) {
//            _pressingHighlightRange = _savedPressingHighlightRange;
//            [touchView setNeedsDisplayMainThread];
//        }
//    }
//    }
//    
//    - (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    _savedPressingHighlightRange = nil;
//    PPTextHighlightRange *high = self.pressingHighlightRange;
//    if (high) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self eventDelegateDidPressHighlightRange:high];
//            });
//        self.pressingHighlightRange = nil;
//        PPAsyncDrawingView *touchView = self.eventDelegateContextView;
//        [touchView setNeedsDisplayMainThread];
//    } else if (self.textLayout.highlighttextBackground) {
//        PPAsyncDrawingView *touchView = self.eventDelegateContextView;
//        self.highlight = NO;
//        [touchView setNeedsDisplayMainThread];
//        
//    }
//    }
//    
//    - (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    _savedPressingHighlightRange = nil;
//    if (_pressingHighlightRange) {
//        _pressingHighlightRange = nil;
//        PPAsyncDrawingView *touchView = self.eventDelegateContextView;
//        [touchView setNeedsDisplayMainThread];
//    } else if (self.textLayout.highlighttextBackground) {
//        PPAsyncDrawingView *touchView = self.eventDelegateContextView;
//        self.highlight = NO;
//        [touchView setNeedsDisplayMainThread];
//    }
//}

extension AsyncTextRenderer {
    
    func convertPointToLayout(_ point: CGPoint) -> CGPoint {
        let drawingOrigin = self.drawingOrigin
        return CGPoint(x: point.x - drawingOrigin.x, y: point.y - drawingOrigin.y)
    }
    
    func convertPointFromLayout(_ point: CGPoint) -> CGPoint {
        let drawingOrigin = self.drawingOrigin
        return CGPoint(x: point.x + drawingOrigin.x, y: point.y + drawingOrigin.y)
    }
    
    func convertRectToLayout(_ rect: CGRect) -> CGRect {
        if rect.isNull {
            return rect
        } else {
            var rect = rect
            rect.origin = convertPointToLayout(rect.origin)
            return rect
        }
    }
    
    func convertRectFromLayout(_ rect: CGRect) -> CGRect {
        if rect.isNull {
            return rect
        } else {
            var rect = rect
            rect.origin = convertPointFromLayout(rect.origin)
            return rect
        }
    }
}

extension AsyncTextRenderer {
    
    public func draw(_ ctx: CGContext, visibleRect: CGRect = .null, placeAttachments: Bool = true) {
        guard let attributedString = textLayout.attributedString, attributedString.length > 1 else { return }
        if !visibleRect.isNull {
            textLayout.maxSize = visibleRect.size
        }
        
        guard let layoutFrame = textLayout.nowLayoutFrame() else { return }
        
        
        if AsyncTextRenderer.debugModeEnabled {
            drawdebugMode(layoutFrame, ctx: ctx)
        }
        
        if let highlight = pressingHighlight {
            textLayout.enumerateEnclosingRectsForCharacterRange(highlight.range, usingBlock: { [weak self] rect, stop in
                guard let `self` = self else { return }
                let drawRect = self.convertRectFromLayout(rect)
                self.drawBorder(highlight.border, rect: drawRect, ctx: ctx)
            })
        }
        
        if let highlightTextBackground = textLayout.highlightTextBackground {
            drawTextBackground(highlightTextBackground, ctx: ctx)
        }
        drawText(layoutFrame, ctx: ctx)
    }
    
    func drawBorder(_ border: AsyncTextBorder?, rect: CGRect, ctx: CGContext) {
        guard let border = border else { return }
        let color: CGColor
        if let fillColor = border.fillColor {
            color = fillColor.cgColor
        } else {
            color = UIColor(white: 0.5, alpha: 1.0).cgColor
        }
        ctx.setFillColor(color)
        ctx.beginPath()
        var x = rect.minX
        var y = rect.minY
        let w = rect.width
        let h = rect.height
        let radius = border.cornerRadius
        ctx.move(to: CGPoint(x: x + radius, y: y))
        x += w
        ctx.addLine(to: CGPoint(x: x + w - radius, y: y))
        ctx.addArc(center: CGPoint(x: x - radius, y: y + radius), radius: radius, startAngle: -0.5 * .pi, endAngle: 0, clockwise: false)
        y += h
        ctx.addLine(to: CGPoint(x: x, y: y))
        ctx.addArc(center: CGPoint(x: x - radius, y: y - radius), radius: radius, startAngle: 0, endAngle: 0.5 * .pi, clockwise: false)
        x -= w
        ctx.addLine(to: CGPoint(x: x + radius, y: y))
        ctx.addArc(center: CGPoint(x: x + radius, y: y - radius), radius: radius, startAngle: 0.5 * .pi, endAngle: .pi, clockwise: false)
        y -= h
        ctx.addLine(to: CGPoint(x: x, y: y))
        ctx.addArc(center: CGPoint(x: x + radius, y: y + radius), radius: radius, startAngle: .pi, endAngle: 1.5 * .pi, clockwise: false)
        ctx.closePath()
        ctx.fillPath()
    }
    
    func drawTextBackground(_ textBackground: AsyncTextBackground, ctx: CGContext) {
        ctx.saveGState()
        ctx.setFillColor(textBackground.backgroundColor.cgColor)
        ctx.fill(CGRect(origin: drawingOrigin, size: textLayout.maxSize))
        ctx.restoreGState()
    }
    
    func drawText(_ layoutFrame: AsyncTextFrame, ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: drawingOrigin.x, y: drawingOrigin.y + frame.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        layoutFrame.lineFragments.forEach { line in
            let position = textLayout.convertPointToCoreText(line.baselineOrigin)
            ctx.textMatrix = .identity
            ctx.textPosition = position
            CTLineDraw(line.line, ctx)
        }
        ctx.restoreGState()
    }
}

extension AsyncTextRenderer {
    
    func highlightRangeForLayoutLocation(_ location: CGPoint) -> AsyncTextHighlight? {
        guard let attributedString = textLayout.attributedString else { return nil }
        var result: AsyncTextHighlight? = nil
        attributedString.enumerateAttribute(NSAttributedStringKey(rawValue: AsyncTextHighlightAttributeName), in: attributedString.range, options: [], using: { [weak self] value, range, stop in
            guard let `self` = self else { return }
            if var high = value as? AsyncTextHighlight {
                self.textLayout.enumerateEnclosingRectsForCharacterRange(range, usingBlock: { rect, sstop in
                    if rect.contains(location) {
                        high.range = range
                        result = high
                        sstop.pointee = true
                        stop.pointee = true
                        return
                    }
                })
            }
        })
        return result
    }
}

extension AsyncTextRenderer {
    
    func drawdebugMode(_ layoutFrame: AsyncTextFrame, ctx: CGContext) {
        let origin = drawingOrigin
        let size = textLayout.maxSize
        ctx.saveGState()
        ctx.setAlpha(0.1)
        ctx.setFillColor(UIColor.gray.cgColor)
        ctx.fill(CGRect(origin: origin, size: size))
        ctx.restoreGState()
        
        layoutFrame.lineFragments.forEach { [unowned self] line in
            let rect = self.convertRectFromLayout(line.fragmentRect())
            ctx.saveGState()
            ctx.setAlpha(0.5)
            ctx.setFillColor(UIColor.yellow.cgColor)
            ctx.fill(rect)
            
            ctx.setAlpha(1)
            ctx.setFillColor(UIColor.red.cgColor)
            ctx.fill(CGRect(x: line.baselineOrigin.x + origin.x, y: line.baselineOrigin.y + origin.y, width: rect.size.width, height: 0.5))
            ctx.restoreGState()
        }
    }
}
