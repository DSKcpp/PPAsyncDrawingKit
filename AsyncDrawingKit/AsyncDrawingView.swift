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
    
    public typealias AsyncBoolBlock = (Bool) -> Void
    public typealias AsyncCompletionBlock = (Bool, Bool) -> Void
    
    public var drawingStart: AsyncBoolBlock?
    public var drawingFinish: AsyncCompletionBlock?
    
    open func setNeedsDisplayMainThread() {
        viewStatus = .touch
        setNeedsDisplay()
    }
    
    // don't override this property
    override open class var layerClass: AnyClass {
        return AsyncDrawingViewLayer.self
    }

    enum ViewStatus {
        case normal
        case touch
    }
    
    private(set) var viewStatus = ViewStatus.normal
    
    var drawingCount: Int32 {
        return asynclayer.drawingCount
    }
    
    private static let concurrentQueue = ConcurrentQueue(name: "io.67373.drawQueue", qos: .userInteractive)
    
    private var drawQueue: DispatchQueue {
        return AsyncDrawingView.concurrentQueue.idle()
    }

    private var asynclayer: AsyncDrawingViewLayer {
        return layer as! AsyncDrawingViewLayer
    }
    
    private var drawCurrentContentAsync: Bool {
        if viewStatus == .touch {
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
        layer.contentsScale = Configs.Screen.scale
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
            
            let scale = layer.contentsScale
            UIGraphicsBeginImageContextWithOptions(size, layer.isOpaque, scale)
            guard let ctx = UIGraphicsGetCurrentContext() else {
                interruped(isAsync)
                return
            }
            ctx.saveGState()
            
            if needCancel() {
                ctx.restoreGState()
                UIGraphicsEndImageContext()
                interruped(isAsync)
                return
            }
            
            if let backgroundColor = self.backgroundColor, backgroundColor != .clear {
                ctx.setFillColor(backgroundColor.cgColor)
                ctx.fill(CGRect(origin: .zero, size: CGSize(width: size.width * scale, height: size.height * scale)))
            }
            
            let drawingSuccess = self.draw(CGRect(origin: .zero, size: size), in: ctx, async: isAsync)
            ctx.restoreGState()
            
            if !drawingSuccess || needCancel() {
                UIGraphicsEndImageContext()
                interruped(isAsync)
                return
            }
            
            var image: UIImage?
            if let imageRef = ctx.makeImage() {
                image = UIImage(cgImage: imageRef)
            }
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                if needCancel() {
                    interruped(isAsync)
                    return
                }
                
                layer.contents = image?.cgImage
                
                self.clearsContextBeforeDrawing = true
                self.viewStatus = .normal
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
}

extension AsyncDrawingView {
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override open func display(_ layer: CALayer) {
        display(asynclayer, rect: asynclayer.bounds, started: { [weak self] async in
            self?.drawingWillStartAsync(async)
            }, finished: { [weak self] async in
                self?.drawingDidFinishAsync(async, success: true)
            }, interruped: { [weak self] async in
                self?.drawingDidFinishAsync(async, success: false)
        })
    }
}

private extension AsyncDrawingView {
    
    func drawingWillStartAsync(_ async: Bool) {
        guard let drawingStart = drawingStart else { return }
        DispatchQueue.main.async {
            drawingStart(async)
        }
    }
    
    func drawingDidFinishAsync(_ async: Bool, success: Bool) {
        guard let drawingFinish = drawingFinish else { return }
        DispatchQueue.main.async {
            drawingFinish(async, success)
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
