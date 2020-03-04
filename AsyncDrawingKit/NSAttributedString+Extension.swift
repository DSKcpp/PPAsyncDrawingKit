//
//  NSAttributedString+Extension.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/15.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    
    var range: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    func heightConstrained(toWidth width: CGFloat) -> CGFloat {
        return sizeConstrained(toWidth: width).height
    }
    
    func sizeConstrained(toWidth width: CGFloat, numberOfLines: Int = 0) -> CGSize {
        return sizeConstrained(toSize: CGSize(width: width, height: 20000), numberOfLines: numberOfLines)
    }
    
    func sizeConstrained(toSize size: CGSize, numberOfLines: Int = 0) -> CGSize {
        let textLayout = Thread.current.textLayout
        textLayout.numberOfLines = numberOfLines
        textLayout.attributedString = self
        textLayout.maxSize = size
        return textLayout.layoutSize
    }
}

extension NSMutableAttributedString {
    
    func effectiveRange(with range: NSRange) -> NSRange {
        let max = range.location + range.length
        if max > length {
            return NSRange(location: range.location, length: length)
        }
        return range
    }
    
    func setAttribute(_ name: NSAttributedString.Key, value: Any?) {
        setAttribute(name, value: value, range: range)
    }
    
    func setAttribute(_ name: NSAttributedString.Key, value: Any?, range: NSRange) {
        let range = effectiveRange(with: range)
        if let value = value {
            addAttribute(name, value: value, range: range)
        } else {
            removeAttribute(name, range: range)
        }
    }
    
    func setKerning(_ kerning: CGFloat) {
        setKerning(kerning, range: range)
    }
    
    func setKerning(_ kerning: CGFloat, range: NSRange) {
        var k = kerning
        let number = CFNumberCreate((CFAllocatorGetDefault() as! CFAllocator), CFNumberType.cgFloatType, &k)
        setAttribute(.kern, value: number, range: range)
    }

    func setColor(_ color: UIColor) {
        setColor(color, range: range)
    }
    
    func setColor(_ color: UIColor, range: NSRange) {
        setAttribute(.foregroundColor, value: color, range: range)
    }

    func setFont(_ font: UIFont) {
        setFont(font, range: range)
    }
    
    func setFont(_ font: UIFont, range: NSRange) {
        setAttribute(.font, value: font, range: range)
    }
    
    func setTextParagraphStyle(_ textParagraphStyle: NSParagraphStyle) {
        setTextParagraphStyle(textParagraphStyle, range: range)
    }
    
    func setTextParagraphStyle(_ textParagraphStyle: NSParagraphStyle, range: NSRange) {
        setAttribute(.paragraphStyle, value: textParagraphStyle, range: range)
    }
    
    func setAlignment(_ aligment: NSTextAlignment) {
        
    }
    
    func setAlignment(_ aligment: NSTextAlignment, lineBreakMode: NSLineBreakMode = .byWordWrapping, lineHeight: CGFloat = 0, range: NSRange) {
        setAttribute(.paragraphStyle, value: <#T##Any?#>, range: <#T##NSRange#>)
        
        
        CTParagraphStyleSetting aligmentStyle;
        CTTextAlignment aligment = NSTextAlignmentToCTTextAlignment(alignment);
        aligmentStyle.value = &aligment;
        aligmentStyle.valueSize = sizeof(CTTextAlignment);
        aligmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        
        CTParagraphStyleSetting lineBreakModelStyle;
        CTLineBreakMode lineBreak = NSLineBreakModeToCTLineBreakMode(lineBreakMode);
        lineBreakModelStyle.value = &lineBreak;
        lineBreakModelStyle.valueSize = sizeof(CTLineBreakMode);
        lineBreakModelStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
        
        CTParagraphStyleSetting settings[2] = {aligmentStyle, lineBreakModelStyle};
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
        [self pp_setAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:self.pp_stringRange];
        CFRelease(paragraphStyle);
    }


    - (void)pp_setLineHeight:(CGFloat)lineHeight
    {
        [self pp_setLineHeight:lineHeight inRange:self.pp_stringRange];
    }

    - (void)pp_setLineHeight:(CGFloat)lineHeight inRange:(NSRange)range
    {
        CTParagraphStyleSetting minimumLineHeight;
        minimumLineHeight.value = &lineHeight;
        minimumLineHeight.valueSize = sizeof(CGFloat);
        minimumLineHeight.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
        
        CTParagraphStyleSetting settings[1] = {minimumLineHeight};
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);
        [self pp_setAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:range];
        CFRelease(paragraphStyle);
    }

    - (void)pp_setCTRunDelegate:(CTRunDelegateRef)ctRunDelegate
    {
        [self pp_setCTRunDelegate:ctRunDelegate inRange:self.pp_stringRange];
    }

    - (void)pp_setCTRunDelegate:(CTRunDelegateRef)ctRunDelegate inRange:(NSRange)range
    {
        [self pp_setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id _Nullable)(ctRunDelegate) range:range];
    }
}
