//
//  AsyncDrawingView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/1.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncDrawingView: UIView {
    
    public static var globallyAsyncDrawingEnabled = true
    
    public var asyncDrawing = true
    
    public typealias AsyncEmptyBlock = () -> Void
    public typealias AsyncBoolBlock = (Bool) -> Void
    public typealias AsyncCompletionBlock = (Bool, Bool) -> Void
    
    public var drawingWillStart: AsyncBoolBlock?
    public var drawingDidFinish: AsyncCompletionBlock?
    
    open func setNeedsDisplayInMainThread() {
        isTouched = true
        setNeedsDisplay()
    }
    
    // don't override
    override open class var layerClass: AnyClass {
        return AsyncDrawingViewLayer.self
    }

    private(set) var isTouched = false
    
    private var drawingCount: Int32 {
        return asyncLayer.drawingCount
    }
    
    private var drawQueue: DispatchQueue {
        return Queue.concurrentQueueGroup.idleQueue()
    }

    private var asyncLayer: AsyncDrawingViewLayer {
        return layer as! AsyncDrawingViewLayer
    }
    
    private var drawCurrentContentAsync: Bool {
        if isTouched {
            return false
        } else {
            return asyncDrawing
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    
    private func initial() {
        isOpaque = false
        layer.contentsScale = Define.Screen.scale
    }
}

extension AsyncDrawingView {
    
    @objc func draw(_ rect: CGRect, in ctx: CGContext, async: Bool) -> Bool {
        fatalError("🔥 This method must be overridden")
    }
}

private extension AsyncDrawingView {
    
    func display(_ layer: AsyncDrawingViewLayer, rect: CGRect, started: @escaping AsyncBoolBlock, finished: @escaping AsyncBoolBlock, interruped: @escaping AsyncBoolBlock) {
        
        let isAsync = drawCurrentContentAsync && AsyncDrawingView.globallyAsyncDrawingEnabled
        
        layer.increaseDrawingCount()
        let drawCount = layer.drawingCount
        
        func needCancel() -> Bool {
            return drawCount != layer.drawingCount
        }
        
        let drawingContents: () -> Void = {
            guard !needCancel() else {
                interruped(isAsync)
                return
            }
            
            let size = layer.bounds.size
            guard size != .zero else {
                interruped(isAsync)
                return
            }
            
            let image = self.getContextImage(isAsync: isAsync, size: size, needCancel: needCancel, interruped: {
                interruped(isAsync)
            })
            
            if image == nil {
                interruped(isAsync)
                return
            }
            
            DispatchQueue.main.async {
                if needCancel() {
                    interruped(isAsync)
                    return
                }
                
                layer.contents = image!.cgImage
                
                self.clearsContextBeforeDrawing = true
                self.isExclusiveTouch = false
                finished(isAsync)
            }
        }
        
        started(isAsync)
        
        if isAsync {
            if clearsContextBeforeDrawing {
                layer.contents = nil
            }
            drawQueue.async(execute: drawingContents)
        } else if Thread.isMainThread {
            drawingContents()
        } else {
            DispatchQueue.main.async(execute: drawingContents)
        }
    }
    
    func getContextImage(isAsync: Bool, size: CGSize, needCancel: @escaping (() -> Bool), interruped: @escaping AsyncEmptyBlock) -> UIImage? {
        var image: UIImage?
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            var success = false
            image = renderer.image(actions: { ctx in
                ctx.cgContext.saveGState()
                
                if needCancel() {
                    ctx.cgContext.restoreGState()
                    interruped()
                    return
                }
                
                if let backgroundColor = self.backgroundColor, backgroundColor != .clear {
                    ctx.cgContext.setFillColor(backgroundColor.cgColor)
                    ctx.fill(CGRect(origin: .zero, size: size))
                }
                
                let drawingSuccess = self.draw(CGRect(origin: .zero, size: size), in: ctx.cgContext, async: isAsync)
                ctx.cgContext.restoreGState()
                
                if !drawingSuccess || needCancel() {
                    interruped()
                    return
                }
                success = true
            })
            if !success {
                return nil
            }
        } else {
            let scale = layer.contentsScale
            UIGraphicsBeginImageContextWithOptions(size, layer.isOpaque, scale)
            guard let ctx = UIGraphicsGetCurrentContext() else {
                interruped()
                return nil
            }
            ctx.saveGState()
            
            if needCancel() {
                ctx.restoreGState()
                UIGraphicsEndImageContext()
                interruped()
                return nil
            }
            
            if let backgroundColor = self.backgroundColor, backgroundColor != .clear {
                ctx.setFillColor(backgroundColor.cgColor)
                ctx.fill(CGRect(origin: .zero, size: CGSize(width: size.width * scale, height: size.height * scale)))
            }
            
            let drawingSuccess = self.draw(CGRect(origin: .zero, size: size), in: ctx, async: isAsync)
            ctx.restoreGState()
            
            if !drawingSuccess || needCancel() {
                UIGraphicsEndImageContext()
                interruped()
                return nil
            }
            
            if let imageRef = ctx.makeImage() {
                image = UIImage(cgImage: imageRef)
            }
            UIGraphicsEndImageContext()
        }
        return image
    }
}

extension AsyncDrawingView {
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override open func display(_ layer: CALayer) {
        display(asyncLayer, rect: asyncLayer.bounds, started: { [weak self] async in
            self?._drawingWillStart(async)
        }, finished: { [weak self] async in
            self?._drawingDidFinish(async, success: true)
        }, interruped: { [weak self] async in
            self?._drawingDidFinish(async, success: false)
        })
    }
}

private extension AsyncDrawingView {
    
    func _drawingWillStart(_ async: Bool) {
        guard let drawingWillStart = drawingWillStart else { return }
        DispatchQueue.main.async {
            drawingWillStart(async)
        }
    }
    
    func _drawingDidFinish(_ async: Bool, success: Bool) {
        guard let drawingDidFinish = drawingDidFinish else { return }
        DispatchQueue.main.async {
            drawingDidFinish(async, success)
        }
    }
}

private final class AsyncDrawingViewLayer: CALayer {
    
    public private(set) var drawingCount: Int32 = 0
    
    func increaseDrawingCount() {
        OSAtomicIncrement32(&drawingCount)
    }
    
    override func setNeedsDisplay() {
        increaseDrawingCount()
        super.setNeedsDisplay()
    }
    
    override func setNeedsDisplay(_ r: CGRect) {
        increaseDrawingCount()
        super.setNeedsDisplay(r)
    }
}
