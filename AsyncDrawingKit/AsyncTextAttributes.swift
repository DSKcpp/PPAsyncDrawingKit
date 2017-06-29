//
//  AsyncTextAttributes.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/15.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

public let AsyncTextHighlightAttributeName: String = "AsyncTextHighlightAttribute"

public struct AsyncTextHighlight {
    var range: NSRange
    var userInfo: [String : Any] = [:]
    var textColor: UIColor
    var font: UIFont
    var border: AsyncTextBorder
}

public struct AsyncTextBorder {
    var fillColor: UIColor?
    var cornerRadius: CGFloat = 4
}

public struct AsyncTextBackground {
    var userInfo: [String : Any] = [:]
    var backgroundColor: UIColor
}
