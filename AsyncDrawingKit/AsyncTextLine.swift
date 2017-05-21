//
//  AsyncTextLine.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/11.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

class AsyncTextLine {
    
    let baselineOrigin: CGPoint
    let line: CTLine
    let stringRange: NSRange
    let width: CGFloat
    private(set) var fontMetrics = AsyncTextFontMetrics()

    init(CTLine: CTLine, origin: CGPoint) {
        baselineOrigin = origin
        line = CTLine
        let range = CTLineGetStringRange(line)
        stringRange = range.nsRange()
        width = CGFloat(CTLineGetTypographicBounds(line, &fontMetrics.ascent, &fontMetrics.descent, &fontMetrics.leading))
    }

    func fragmentRect() -> CGRect {
        let height = fontMetrics.ascent + fontMetrics.descent
        return CGRect(x: baselineOrigin.x, y: baselineOrigin.y - fontMetrics.ascent, width: width, height: height)
    }
    
    func forEach(_ body: ([String : Any], NSRange) throws -> Void) rethrows {
        let runs = CTLineGetGlyphRuns(line)
        let count = CFArrayGetCount(runs)
        if count > 0 {
            let runs = runs as! [CTRun]
            runs.forEach { run in
                let attrs = CTRunGetAttributes(run) as! [String : Any]
                let range = CTRunGetStringRange(run).nsRange()
                do {
                    try body(attrs, range)
                } catch {
                    return
                }
            }
        }
    }
    
    func offsetXForCharacterAtIndex(_ index: Int) -> CGFloat {
        return CTLineGetOffsetForStringIndex(line, index, nil)
    }
    
    func baselineOriginForCharacterAtIndex(_ index: Int) -> CGPoint {
        let point = baselineOrigin
        let x = offsetXForCharacterAtIndex(index)
        return CGPoint(x: x, y: point.y)
    }
    
    func characterIndexForBoundingPosition(_ position: CGPoint) -> Int {
        return CTLineGetStringRange(line).length
    }
}
