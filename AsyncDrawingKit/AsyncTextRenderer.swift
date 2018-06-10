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
}

public final class AsyncTextRenderer: UIResponder {
    
    var textLayout: AsyncTextLayout!
    weak var delegate: AsyncTextRendererEventDelegate?
    var pressingSelected: AsyncTextSelected?
    private lazy var touchesBeginPoint: CGPoint = .zero
    
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
            point = convertPointToLayout(point)
        }
        
        if let selected = selectedRangeForLayoutLocation(point) {
            pressingSelected = selected
            touchView.setNeedsDisplayMainThread()
        }
        touchesBeginPoint = point
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if let touchView = delegate?.contextViewForTextRenderer(self) {
        //            let touches = event?.touches(for: touchView)
        //            var point = CGPoint.zero
        //            if let touch = touches?.first {
        //                point = touch.location(in: touchView)
        //                point = convertPointToLayout(point)
        //            }
        //            var touchInside = false
        //            if let pressingBorder = pressingBorder {
        //                touchInside = pressingBorder.rect.contains(point)
        //            }
        //
        //            print(touchInside)
        //        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchView = delegate?.contextViewForTextRenderer(self) {
            let touches = event?.touches(for: touchView)
            var point = CGPoint.zero
            if let touch = touches?.first {
                point = touch.location(in: touchView)
                point = convertPointToLayout(point)
            }
            
            var touchInside = false
            if let pressingSelected = pressingSelected {
                touchInside = pressingSelected.rect.contains(point)
                if touchInside {
                    pressingSelected.selected?(pressingSelected.userInfo)
                }
                touchView.setNeedsDisplayMainThread()
            }
        }
        pressingSelected = nil
        touchesBeginPoint = .zero
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchView = delegate?.contextViewForTextRenderer(self) {
            if let _ = pressingSelected {
                touchView.setNeedsDisplayMainThread()
            }
        }
        
        pressingSelected = nil
        touchesBeginPoint = .zero
    }
}

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
        guard let attributedString = textLayout.attributedString, attributedString.length > 0 else { return }
        if !visibleRect.isNull {
            textLayout.maxSize = visibleRect.size
        }
        guard let layoutFrame = textLayout.nowLayoutFrame() else { return }
        if AsyncTextRenderer.debugModeEnabled {
            drawdebugMode(layoutFrame, ctx: ctx)
        }
        
        if let pressingSelected = pressingSelected {
            if let border = pressingSelected.border {
                textLayout.enumerateEnclosingRectsForCharacterRange(pressingSelected.range, usingBlock: { (rect, stop) in
                    let drawRect = convertRectFromLayout(rect)
                    drawBorder(border, rect: drawRect, ctx: ctx)
                })
            }
        }
        
        if let highlightTextBackground = textLayout.highlightTextBackground {
            drawTextBackground(highlightTextBackground, ctx: ctx)
        }
        drawText(layoutFrame, ctx: ctx)
    }
    
    func drawBorder(_ border: AsyncTextBorder, rect: CGRect, ctx: CGContext) {
        let color: CGColor
        if let fillColor = border.fillColor {
            color = fillColor.cgColor
        } else {
            color = UIColor(white: 0.5, alpha: 1.0).cgColor
        }
        ctx.saveGState()
        ctx.setFillColor(color)
        let radius = border.cornerRadius
        if radius <= 0 {
            ctx.fill(rect)
        } else {
            ctx.beginPath()
            var x = rect.minX
            var y = rect.minY
            let w = rect.width
            let h = rect.height
            
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
        ctx.restoreGState()
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
    
    func selectedRangeForLayoutLocation(_ location: CGPoint) -> AsyncTextSelected? {
        guard let attributedString = textLayout.attributedString else { return nil }
        var result: AsyncTextSelected? = nil
        attributedString.enumerateAttribute(.selected, in: attributedString.range, options: [], using: { [weak self] value, range, stop in
            guard let `self` = self else { return }
            if var sel = value as? AsyncTextSelected {
                self.textLayout.enumerateEnclosingRectsForCharacterRange(range, usingBlock: { rect, sstop in
                    if rect.contains(location) {
                        sel.rect = rect
                        result = sel
                        sstop.pointee = true
                        stop.pointee = true
                        return
                    }
                })
            }
        })
        return result
    }
    
    func borderForLayoutLocation(_ location: CGPoint) -> AsyncTextBorder? {
        guard let attributedString = textLayout.attributedString else { return nil }
        var result: AsyncTextBorder? = nil
        attributedString.enumerateAttribute(.border, in: attributedString.range, options: []) { [weak self] value, range, stop in
            guard let `self` = self else { return }
            if var border = value as? AsyncTextBorder {
                self.textLayout.enumerateEnclosingRectsForCharacterRange(range, usingBlock: { rect, sstop in
                    if rect.contains(location) {
                        border.rect = rect
                        result = border
                        sstop.pointee = true
                        stop.pointee = true
                        return
                    }
                })
            }
        }
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
