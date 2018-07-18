//
//  AsyncTextAttributes.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/15.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

public typealias UserInfo = [String: Any]

public struct AsyncTextSelected {
    
    public var rect: CGRect = .zero
    public var range: NSRange = NSRange(location: 0, length: 0)
    public var userInfo: UserInfo?
    public var selected: ((UserInfo?) -> Void)?
    public var border: AsyncTextBorder?
    
    public init() {
        
    }
    
    public init(rect: CGRect, range: NSRange, userInfo: [String: Any]?, selected: (([String: Any]?) -> Void)?, border: AsyncTextBorder?) {
        self.rect = rect
        self.range = range
        self.userInfo = userInfo
        self.selected = selected
        self.border = border
    }
}

public struct AsyncTextBorder {
    
    public var fillColor: UIColor?
    public var cornerRadius: CGFloat = 4
    public var rect: CGRect = .zero
    
    public init(fillColor: UIColor?, cornerRadius: CGFloat = 4) {
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
    }
}

public struct AsyncTextBackground {
    var userInfo: [String : Any] = [:]
    var backgroundColor: UIColor
}

extension NSAttributedString.Key {
    
    public static let border = NSAttributedString.Key("NSAttributedStringKeyAsyncBorder")
    public static let selected = NSAttributedString.Key("NSAttributedStringKeyAsyncSelected")
}
