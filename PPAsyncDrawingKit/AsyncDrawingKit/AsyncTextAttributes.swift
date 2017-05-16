//
//  AsyncTextAttributes.swift
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/15.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

let AsyncTextHighlightAttributeName: String = "AsyncTextHighlightAttribute"

struct AsyncTextHighlight {
    var range: NSRange
    var userInfo: [String : Any] = [:]
    var textColor: UIColor
    var font: UIFont
    var border: AsyncTextBorder
}

struct AsyncTextBorder {
    var fillColor: UIColor?
    var cornerRadius: CGFloat = 4
}

struct AsyncTextBackground {
    var userInfo: [String : Any] = [:]
    var backgroundColor: UIColor
}
