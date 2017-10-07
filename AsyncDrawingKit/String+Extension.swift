//
//  String+Extension.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/3.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func size(with font: UIFont = UIFont.systemFont(ofSize: 15.0),
              width: CGFloat,
              lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        
        return self.size(with: font, constrained: CGSize(width: width, height: .greatestFiniteMagnitude), lineBreakMode: lineBreakMode)
    }
    
    func size(with font: UIFont = UIFont.systemFont(ofSize: 15.0),
              constrained size: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude),
              lineBreakMode: NSLineBreakMode) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let attr = [NSAttributedStringKey.font : font, NSAttributedStringKey.paragraphStyle : paragraphStyle]
        
        let text = self as NSString
        return text.boundingRect(with: size,
                                 options: [.usesFontLeading, .usesLineFragmentOrigin],
                                 attributes: attr,
                                 context: nil).size
    }
}
