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
