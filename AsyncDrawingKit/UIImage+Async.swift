//
//  UIImage+Async.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/6/8.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func convertRect(_ rect: CGRect, with contentModel: UIView.ContentMode) -> CGRect {
        var rect = rect.standardized
        var size = self.size
        size.width = size.width < 0 ? -size.width : size.width
        size.height = size.height < 0 ? -size.height : size.height
        let center = CGPoint(x: rect.midX, y: rect.midY)
        switch contentModel {
        case .scaleAspectFit, .scaleAspectFill:
            if rect.width < 0.01 || rect.height < 0.01 || size.width < 0.01 || size.height < 0.01 {
                rect.origin = center
                rect.size = .zero
            } else {
                var scale: CGFloat
                if contentModel == .scaleAspectFit {
                    if size.width / size.height < rect.width / rect.height {
                        scale = rect.height / size.height
                    } else {
                        scale = rect.width / size.width
                    }
                } else {
                    if size.width / size.height < rect.width / rect.height {
                        scale = rect.width / size.width
                    } else {
                        scale = rect.height / size.height
                    }
                }
                
                size.width *= scale
                size.height *= scale
                rect.size = size
                rect.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
            }
        case .center:
            rect.size = size
            rect.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        case .top:
            rect.origin.x = center.x - size.width * 0.5
            rect.size = size
        case .bottom:
            rect.origin.x = center.x - size.width * 0.5
            rect.origin.y += rect.height - size.height
            rect.size = size
        case .left:
            rect.origin.y = center.y - size.height * 0.5
            rect.size = size
        case .right:
            rect.origin.y = center.y - size.height * 0.5
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .topLeft:
            rect.size = size
        case .topRight:
            rect.origin.x += rect.width - size.width
            rect.size = size
        case .bottomLeft:
            rect.origin.y += rect.height - size.height
            rect.size = size
        case .bottomRight:
            rect.origin.x += rect.width - size.width
            rect.origin.y += rect.height - size.height
            rect.size = size
        default:
            break
        }
        
        return rect
    }
    
    func draw(in rect: CGRect, contentMode: UIView.ContentMode, with ctx: CGContext) {
        var clip = false
        var rect = rect
        let originalRect = rect
        if size.width != rect.width || size.height != rect.height {
            clip = contentMode != .scaleAspectFill && contentMode != .scaleAspectFit
            rect = convertRect(rect, with: contentMode)
        }
        
        if clip {
            ctx.saveGState()
            ctx.addRect(originalRect)
            ctx.clip()
        }
        
        defer {
            if clip {
                ctx.restoreGState()
            }
        }
        
        draw(in: rect)
    }
}
