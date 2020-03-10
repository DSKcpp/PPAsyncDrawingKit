//
//  String+Regex.swift
//  AsyncDrawingKit-Example
//
//  Created by 池鹏鹏 on 2020/3/8.
//  Copyright © 2020 池鹏鹏. All rights reserved.
//

import Foundation

extension String {
    
    func isMatchedBy(regex: String) -> Bool {
        return isMatchedBy(regex: regex, range: NSRange(location: 0, length: count))
    }
    
    func isMatchedBy(regex: String, options: NSRegularExpression.Options = [], range: NSRange) -> Bool {
        do {
            let regular = try NSRegularExpression.init(pattern: regex, options: options)
            let result = regular.firstMatch(in: regex, options: [], range: range)
            return result != nil
        } catch {
            return false
        }
    }
    
    func enumerateStringsMatchedBy(regex: String, options: NSRegularExpression.Options = [], result: (String, NSRange)->()) {
        do {
            let regular = try NSRegularExpression.init(pattern: regex, options: options)
            regular.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: count)) { r, flage, stop in
                if let r = r {
                    let range = r.range
                    let start = index(startIndex, offsetBy: range.lowerBound)
                    let end = index(startIndex, offsetBy: range.upperBound)
                    let text = String(self[start..<end])
                    result(text, range)
                }
            }
        } catch {
            print(error)
        }
    }
}


