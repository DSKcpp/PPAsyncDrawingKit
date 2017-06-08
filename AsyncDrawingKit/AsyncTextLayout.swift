//
//  AsyncTextLayout.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/11.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

class AsyncTextLayout {
    
    var numberOfLines = 1
    
    fileprivate let lock = Lock()
    
    var text = ""
    var truncationString: NSAttributedString?
    
    fileprivate var _needsLayout = true
    var needsLayout: Bool {
        get {
            lock.lock()
            defer {
                lock.unlock()
            }
            return _needsLayout
        } set {
            guard _needsLayout != newValue else { return }
            lock.lock()
            _needsLayout = newValue
            lock.unlock()
        }
    }
    
    fileprivate var _frame: CGRect = .zero
    
    lazy var textRenderer: AsyncTextRenderer = {
        return AsyncTextRenderer(textLayout: self)
    }()
    
    var highlightTextBackground: AsyncTextBackground?
    
    private var layoutFrame: AsyncTextFrame?
    
    var attributedString: NSAttributedString?
    
    init(attributedString: NSAttributedString?) {
        self.attributedString = attributedString
    }
    
    func nowLayoutFrame() -> AsyncTextFrame? {
        if needsLayout || layoutFrame == nil {
            lock.lock()
            layoutFrame = createLayoutFrame()
            lock.unlock()
            needsLayout = false
        }
        return layoutFrame
    }
    
    fileprivate func createLayoutFrame() -> AsyncTextFrame? {
        guard let attributedString = attributedString, attributedString.length > 0 else { return nil }
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let rect = CGRect(x: 0, y: 0, width: maxSize.width, height: 20000)
        let transform = CGAffineTransform.identity
        let path = CGMutablePath()
        path.addRect(rect, transform: transform)
        let range = CFRange(location: 0, length: attributedString.length)
        let frame = CTFramesetterCreateFrame(framesetter, range, path, nil)
        return AsyncTextFrame(CTFrame: frame, textLayout: self)
    }
    
    func setNeedsLayout() {
        needsLayout = true
    }
    
    func setAttributedString(_ attributedString: NSAttributedString) {
        guard attributedString != self.attributedString else { return }
        lock.lock()
        self.attributedString = attributedString
        text = attributedString.string
        lock.unlock()
        needsLayout = true
    }
    
    func setNumberOfLines(_ numberOfLines: Int) {
        guard numberOfLines != self.numberOfLines else { return }
        self.numberOfLines = numberOfLines
        needsLayout = true
    }
}

extension AsyncTextLayout {
    
    var frame: CGRect {
        get {
            return _frame
        } set {
            guard !_frame.equalTo(newValue) else { return }
            _frame = newValue
            needsLayout = true
        }
    }
    
    var drawOrigin: CGPoint {
        get {
            return _frame.origin
        } set {
            guard !_frame.origin.equalTo(newValue) else { return }
            _frame.origin = newValue
            needsLayout = true
        }
    }
    
    var maxSize: CGSize {
        get {
            return _frame.size
        } set {
            guard !_frame.size.equalTo(newValue) else { return }
            _frame.size = newValue
            needsLayout = true
        }
    }
}

extension AsyncTextLayout {
    
    var containingLineCount: Int {
        return nowLayoutFrame()?.lineFragments.count ?? 0
    }
    
    var layoutSize: CGSize {
        return nowLayoutFrame()?.layoutSize ?? .zero
    }
    
    var layoutHeight: CGFloat {
        return layoutSize.height
    }
    
}

extension AsyncTextLayout {
    
    func convertPointToCoreText(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x, y: maxSize.height - point.y)
    }
    
    func convertPointFromCoreText(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x, y: maxSize.height - point.y)
    }
    
    func convertRectToCoreText(_ rect: CGRect) -> CGRect {
        var rect = rect
        let point = convertPointToCoreText(rect.origin)
        rect.origin = point
        return rect
    }
    
    func convertRectFromCoreText(_ rect: CGRect) -> CGRect {
        var rect = rect
        let point = convertPointFromCoreText(rect.origin)
        rect.origin = point
        return rect
    }
}

extension AsyncTextLayout {
    
    func enumerateLineFragmentsForCharacterRange(_ range: NSRange, usingBlock: (CGRect, NSRange, UnsafeMutablePointer<Bool>) -> Void) {
        nowLayoutFrame()?.enumerateLineFragmentsForCharacterRange(range, usingBlock: usingBlock)
    }
    
    func enumerateEnclosingRectsForCharacterRange(_ range: NSRange, usingBlock: (CGRect, UnsafeMutablePointer<Bool>) -> Void) {
        nowLayoutFrame()?.enumerateEnclosingRectsForCharacterRange(range, usingBlock: usingBlock)
    }
}
