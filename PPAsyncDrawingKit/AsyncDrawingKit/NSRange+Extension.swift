//
//  NSRange+Extension.swift
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/11.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import Foundation

extension NSRange {
    
    func cfRange() -> CFRange {
        return CFRange(location: location, length: length)
    }
    
    func end() -> Int {
        return location + length
    }
}

extension CFRange {
    
    func nsRange() -> NSRange {
        return NSRange(location: location, length: length)
    }
    
    func end() -> CFIndex {
        return location + length
    }
}
