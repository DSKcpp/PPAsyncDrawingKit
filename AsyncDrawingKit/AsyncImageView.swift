//
//  AsyncImageView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/3.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncImageView: AsyncUIControl {
    
    private var _image: UIImage?
    public var image: UIImage? {
        get {
            return Lock().sync { _image }
        } set {
            if _image == newValue {
                if newValue == nil || layer.contents == nil {
                    setNeedsDisplay()
                }
            } else {
                Lock().sync { _image = newValue }
                setNeedsDisplay()
            }
        }
    }
    
    private lazy var _cornerRadius: CGFloat = 0.0
    private lazy var _roundedCorners: UIRectCorner = .allCorners
    
    private lazy var showsCornerRadius: Bool = false
    private lazy var showsBorder: Bool = false
    
    public var cornerRadius: CGFloat {
        get {
            return _cornerRadius
        } set {
            guard _cornerRadius != newValue else { return }
            _cornerRadius = newValue
            showsCornerRadius = newValue > 0
            layer.cornerRadius = 0
            roundPath = nil
            setNeedsDisplay()
        }
    }
    
    public var roundedCorners: UIRectCorner {
        get {
            return _roundedCorners
        } set {
            guard _roundedCorners != newValue else { return }
            _roundedCorners = newValue
            roundPath = nil
            setNeedsDisplay()
        }
    }
    
    private lazy var _borderWidth: CGFloat = 0.0
    private lazy var _borderColor: UIColor = .clear
    
    public var borderWidth: CGFloat {
        get {
            return _borderWidth
        } set {
            guard _borderWidth != newValue else { return }
            _borderWidth = newValue
            showsBorder = newValue > 0
            layer.borderWidth = 0
            borderPath = nil
            setNeedsDisplay()
        }
    }
    
    public var borderColor: UIColor {
        get {
            return _borderColor
        } set {
            guard _borderColor != newValue else { return }
            _borderColor = newValue
            layer.borderColor = nil
            setNeedsDisplay()
        }
    }
    
    private var _borderPath: CGPath?
    private var _roundPath: CGPath?
    
    public var roundPath: CGPath? {
        get {
            return Lock().sync { _roundPath }
        } set {
            guard _roundPath != newValue else { return }
            Lock().sync { _roundPath = newValue }
        }
    }
    
    public var borderPath: CGPath? {
        get {
            return Lock().sync { _borderPath }
        } set {
            guard _borderPath != newValue else { return }
            return Lock().sync { _borderPath = newValue }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        clipsToBounds = true
    }
    
    convenience public init(image: UIImage) {
        self.init()
        
        self.image = image
    }
    
    convenience public init(cornerRadius: CGFloat, by roundingCorners: UIRectCorner = .allCorners) {
        self.init()
        
        self.cornerRadius = cornerRadius
        roundedCorners = roundingCorners
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect, in ctx: CGContext, async: Bool) -> Bool {
        if showsCornerRadius {
            let path = roundPath ?? UIBezierPath.rounded(rect: bounds, cornerRadius: cornerRadius, roundedCorners: roundedCorners)
            roundPath = path
            ctx.addPath(path)
            ctx.clip()
        }
        
        if let image = image {
            image.draw(in: rect, contentMode: contentMode, with: ctx)
        }
        
        if showsBorder {
            let path = borderPath ?? UIBezierPath.rounded(rect: bounds, cornerRadius: cornerRadius, roundedCorners: roundedCorners)
            borderPath = path
            ctx.addPath(path)
            ctx.setLineWidth(borderWidth)
            ctx.setStrokeColor(borderColor.cgColor)
            ctx.strokePath()
        }
        
        return true
    }
    
}

extension AsyncImageView {
    
    open override var frame: CGRect {
        willSet {
            guard frame != newValue else { return }
            roundPath = nil
            borderPath = nil
            setNeedsDisplay()
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let image = image else { return size }
        return image.size
    }
    
}

extension UIBezierPath {
    
    class func rounded(rect: CGRect, cornerRadius: CGFloat, roundedCorners: UIRectCorner) -> CGPath {
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: roundedCorners, cornerRadii: cornerRadii)
        return bezierPath.cgPath
    }
}

