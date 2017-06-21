//
//  AsyncDrawingView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/1.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncDrawingView: UIView {
    
    enum ViewStatus {
        case normal
        case touch
    }
    
    public static var globallyAsyncDrawingEnabled = true
    
    override open class var layerClass: AnyClass {
        return AsyncDrawingViewLayer.self
    }

    fileprivate(set) var viewStatus = ViewStatus.normal
    
    var drawingCount: Int32 {
        return asynclayer.drawingCount
    }
    
    fileprivate let drawQueue = DispatchQueue(label: "io.github.dskcpp.drawQueue", attributes: .concurrent)
    
    var asyncDrawing = true
    
    fileprivate var asynclayer: AsyncDrawingViewLayer {
        return layer as! AsyncDrawingViewLayer
    }
    
    fileprivate var drawCurrentContentAsync: Bool {
        if viewStatus == .touch {
            return false
        } else {
            return asyncDrawing
        }
    }
    
    public typealias Completion = (Bool) -> Void
    
    public var drawingStart: Completion?
    public var drawingFinish: ((Bool, Bool) -> Void)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    
    fileprivate func initial() {
        isOpaque = false
        layer.contentsScale = Configs.Screen.scale
    }
    
    func setNeedsDisplayMainThread() {
        viewStatus = .touch
        setNeedsDisplay()
    }
    
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

extension AsyncDrawingView {
    
    @objc func draw(_ rect: CGRect, in ctx: CGContext, async: Bool) -> Bool {
        fatalError("This method must be overridden")
    }
}

fileprivate extension AsyncDrawingView {
    
    func display(_ layer: AsyncDrawingViewLayer, rect: CGRect, started: @escaping Completion, finished: @escaping Completion, interruped: @escaping Completion) {
        
        var async = false
        if drawCurrentContentAsync && AsyncDrawingView.globallyAsyncDrawingEnabled {
            async = true
        }
        
        layer.increaseDrawingCount()
        let drawCount = layer.drawingCount
        
        func needCancel() -> Bool {
            return drawCount != layer.drawingCount
        }
        
        let drawingContents: () -> Void = {
            guard !needCancel() else { interruped(async); return }
            
            let size = layer.bounds.size
            guard size != .zero else { interruped(async); return }
            
            let scale = layer.contentsScale
            UIGraphicsBeginImageContextWithOptions(size, layer.isOpaque, scale)
            guard let ctx = UIGraphicsGetCurrentContext() else { interruped(async); return }
            ctx.saveGState()
            
            if needCancel() {
                ctx.restoreGState()
                UIGraphicsEndImageContext()
                interruped(async)
                return
            }
            
            if let backgroundColor = self.backgroundColor, backgroundColor != .clear {
                ctx.setFillColor(backgroundColor.cgColor)
                ctx.fill(CGRect(origin: .zero, size: CGSize(width: size.width * scale, height: size.height * scale)))
            }
            
            let drawingSuccess = self.draw(CGRect(origin: .zero, size: size), in: ctx, async: async)
            ctx.restoreGState()
            
            if !drawingSuccess || needCancel() {
                UIGraphicsEndImageContext()
                interruped(async)
                return
            }
            
            var image: UIImage?
            if let imageRef = ctx.makeImage() {
                image = UIImage(cgImage: imageRef)
            }
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                if needCancel() {
                    interruped(async)
                    return
                }
                
                layer.contents = image?.cgImage
                
                self.clearsContextBeforeDrawing = true
                self.viewStatus = .normal
                finished(async)
            }
        }
        
        started(async)
        
        if async {
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

fileprivate extension AsyncDrawingView {
    
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

fileprivate final class AsyncDrawingViewLayer: CALayer {
    
    public private(set) var drawingCount: Int32 = 0
    
    func increaseDrawingCount() {
        OSAtomicIncrement32(&drawingCount)
    }
    
    override func setNeedsDisplay() {
        increaseDrawingCount()
        super.setNeedsDisplay()
    }
    
    override func setNeedsDisplayIn(_ r: CGRect) {
        increaseDrawingCount()
        super.setNeedsDisplayIn(r)
    }
}
