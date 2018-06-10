//
//  AsyncMultiplexTextView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/29.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncMultiplexTextView: AsyncDrawingView {

    fileprivate lazy var internalTextLayouts: [AsyncTextLayout] = []
    var respondTextRenderer: AsyncTextRenderer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawingFinish = { [weak self] async, success in
            if success {
                self?.isHidden = false
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func draw(_ rect: CGRect, in ctx: CGContext, async: Bool) -> Bool {
        internalTextLayouts.forEach { textLayout in
            textLayout.textRenderer.draw(ctx)
        }
        return true
    }
    
}

extension AsyncMultiplexTextView {
    
    public func append(_ textLayout: AsyncTextLayout) {
        textLayout.textRenderer.delegate = self
        internalTextLayouts.append(textLayout)
    }
}

extension AsyncMultiplexTextView {
    
    public func renderer(at point: CGPoint) -> AsyncTextRenderer? {
        return internalTextLayouts.first { $0.frame.contains(point) }?.textRenderer
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var point = CGPoint.zero
        if let touch = touches.first {
            point = touch.location(in: self)
        }
        
        var pressingRange = false
        respondTextRenderer = renderer(at: point)
        
        if let respondTextRenderer = respondTextRenderer {
            respondTextRenderer.touchesBegan(touches, with: event)
            if respondTextRenderer.pressingSelected != nil {
                pressingRange = true
            }
        }
        
        if !pressingRange {
            super.touchesBegan(touches, with: event)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pressingRange = false
        if let respondTextRenderer = respondTextRenderer {
            respondTextRenderer.touchesMoved(touches, with: event)
            if respondTextRenderer.pressingSelected != nil {
                pressingRange = true
            }
        }
        if !pressingRange {
            super.touchesMoved(touches, with: event)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let respondTextRenderer = respondTextRenderer {
            respondTextRenderer.touchesEnded(touches, with: event)
            self.respondTextRenderer = nil
        }
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let respondTextRenderer = respondTextRenderer {
            respondTextRenderer.touchesCancelled(touches, with: event)
            self.respondTextRenderer = nil
        }
        super.touchesCancelled(touches, with: event)
    }
}

extension AsyncMultiplexTextView: AsyncTextRendererEventDelegate {
    
    func contextViewForTextRenderer(_ textRenderer: AsyncTextRenderer) -> AsyncDrawingView? {
        return self
    }
    
}
