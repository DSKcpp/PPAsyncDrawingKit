//
//  NSRange+Extension.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/11.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import Foundation

extension NSRange {
    
    func cfRange() -> CFRange {
        return CFRange(location: location, length: length)
    }
    
    func start() -> Int {
        return location
    }
    
    func end() -> Int {
        return location + length
    }
}

extension CFRange {
    
    func nsRange() -> NSRange {
        return NSRange(location: location, length: length)
    }
    
    func start() -> CFIndex {
        return location
    }
    
    func end() -> CFIndex {
        return location + length
    }
}
