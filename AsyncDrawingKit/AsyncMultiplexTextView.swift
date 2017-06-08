//
//  AsyncMultiplexTextView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/29.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

class AsyncMultiplexTextView: AsyncDrawingView {

    fileprivate var internalTextLayouts: [AsyncTextLayout] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawingFinish = { [weak self] async, success in
            if success {
                self?.isHidden = false
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect, in ctx: CGContext, async: Bool) -> Bool {
        internalTextLayouts.forEach { textLayout in
            textLayout.textRenderer.drawInContext(ctx)
        }
        return true
    }

}
