//
//  AsyncTextFrame.swift
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/11.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

class AsyncTextFrame {
    
    weak var textLayout: AsyncTextLayout!
    
    var lineFragments: [AsyncTextLine] = []
    
    var layoutSize = CGSize.zero
    
    init(CTFrame: CTFrame, textLayout: AsyncTextLayout) {
        self.textLayout = textLayout
    }
    
    func setupWithCTFrame(_ frame: CTFrame) {
        let maxLines = textLayout.numberOfLines
        guard let ctLines = CTFrameGetLines(frame) as? [CTLine], ctLines.count > 0 else { return }
        var lines: [AsyncTextLine] = []
        var origins: [CGPoint] = []
        CTFrameGetLineOrigins(frame, CFRange(location: 0, length: ctLines.count), &origins)
        for (i, line) in ctLines.enumerated() {
            var position = origins[i]
            position.y = 20000 - position.y
            if maxLines == 0 || i != maxLines - 1 {
                let aLine = AsyncTextLine(CTLine: line, origin: position)
                lines.append(aLine)
            } else {
                let stringRange = CTLineGetStringRange(line)
                if stringRange.end() >= textLayout.attributedString?.length ?? 0 {
                    let aLine = AsyncTextLine(CTLine: line, origin: position)
                    lines.append(aLine)
                } else if let truncatedLine = createTruncatedLine(textLayout: textLayout, lastLineStringRange: stringRange) {
                    let aLine = AsyncTextLine(CTLine: truncatedLine, origin: position)
                    lines.append(aLine)
                }
            }
        }
        lineFragments = lines
        updateLayoutSize()
    }
    
    
    func createTruncatedLine(textLayout: AsyncTextLayout, lastLineStringRange: CFRange) -> CTLine? {
        let maxWidth = textLayout.maxSize.width
        let attributedString = textLayout.attributedString
//        let truncateToken: NSAttributedString
        return nil
    }
    
    //
    //
    //    - (CTLineRef)createTruncatedLine:(PPTextLayout *)layout lastLineStringRange:(CFRange)lastLineStringRange
    //    {
    //    CGFloat maxWidth = layout.maxSize.width;
    //    NSAttributedString *attributedString = layout.attributedString;
    //    NSAttributedString *truncateToken;
    //    if (layout.truncationString) {
    //    truncateToken = layout.truncationString;
    //    } else {
    //    NSDictionary<NSString *, id> *truncateTokenAttributes = [attributedString attributesAtIndex:lastLineStringRange.location effectiveRange:nil];
    //    NSArray *keys = @[NSForegroundColorAttributeName, NSFontAttributeName, (id)kCTParagraphStyleAttributeName];
    //    truncateTokenAttributes = [truncateTokenAttributes dictionaryWithValuesForKeys:keys];
    //    NSMutableDictionary *finalTokenAttributes = @{}.mutableCopy;
    //    [truncateTokenAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    //    if (obj != [NSNull null]) {
    //    finalTokenAttributes[key] = obj;
    //    }
    //    }];
    //    truncateToken = [[NSAttributedString alloc] initWithString:@"\u2026" attributes:finalTokenAttributes];
    //    }
    //
    //    CTLineRef truncateTokenLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncateToken);
    //
    //    NSMutableAttributedString *lastLineAttrStr = [attributedString attributedSubstringFromRange:PPNSRangeFromCFRange(lastLineStringRange)].mutableCopy;
    //    [lastLineAttrStr appendAttributedString:truncateToken];
    //
    //    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)lastLineAttrStr);
    //
    //    CTLineRef resuleLineRef = CTLineCreateTruncatedLine(lineRef, maxWidth, kCTLineTruncationEnd, truncateTokenLine);
    //    CFRelease(truncateTokenLine);
    //    if (!resuleLineRef) {
    //    resuleLineRef = CFRetain(lineRef);
    //    }
    //    CFRelease(lineRef);
    //    
    //    return resuleLineRef;
    //    }

    
    func updateLayoutSize() {
        guard lineFragments.count > 0 else { return }
        var rect = CGRect.zero
        for (i, line) in lineFragments.enumerated() {
            if i == 0 {
                rect = line.fragmentRect()
            } else {
                rect = rect.union(line.fragmentRect())
            }
        }
        var size = rect.size
        size.width = ceil(size.width)
        size.height = ceil(size.height)
        layoutSize = size
    }
}

extension AsyncTextFrame {
    
    func enumerateLineFragmentsForCharacterRange(_ range: NSRange, usingBlock: (CGRect, NSRange, UnsafeMutablePointer<Bool>) -> Void) {
        var stop = false
        for (_, line) in lineFragments.enumerated() {
            if stop {
                return
            }
            usingBlock(line.fragmentRect(), line.stringRange, &stop)
        }
    }
    
    func enumerateEnclosingRectsForCharacterRange(_ range: NSRange, usingBlock: (CGRect, UnsafeMutablePointer<Bool>) -> Void) {
        guard lineFragments.count > 0 else { return }
        var stop = false
        lineFragments.forEach { line in
            if stop {
                return
            }
            
            let lineRange = line.stringRange
            if range.location <= lineRange.end() && lineRange.location <= range.end() {
                let x = line.baselineOrigin.x
                let y = line.baselineOrigin.y
                let left = line.offsetXForCharacterAtIndex(range.location) + x
                let right = line.offsetXForCharacterAtIndex(range.location + range.length) + x
                let rect = CGRect.init(x: left, y: y - line.fontMetrics.ascent, width: right - left, height: line.fragmentRect().size.height)
                usingBlock(rect, &stop)
            }
        }
    }
}
