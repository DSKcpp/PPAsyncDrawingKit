//
//  AsyncTextFontMetrics.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/11.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

struct AsyncTextFontMetrics {
    
    var ascent: CGFloat
    var descent: CGFloat
    var leading: CGFloat
    
    static var zero: AsyncTextFontMetrics {
        return AsyncTextFontMetrics(ascent: 0, descent: 0, leading: 0)
    }
}
