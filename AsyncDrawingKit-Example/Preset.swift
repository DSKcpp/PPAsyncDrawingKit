//
//  Preset.swift
//  AsyncDrawingKit-Demo
//
//  Created by DSKcpp on 2017/6/28.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

struct Preset {
    
    typealias T = CGFloat
    
    struct Common {
        static let spacing: T = 12.0
        static let margin: T = 10.0
        static let maxWidth: T = {
            let width = UIScreen.main.bounds.size.width
            return width - spacing * 2
        }()
        static let minHeight: T = 136.0
        static let numberOfLines = 7
        
    }
    
    struct Title {
        static let height: T = 34.0
        static let iconTop: T = 9.5
        static let iconLeft: T = 11.0
        static let iconSize: T = 15.0
        static let fontSize: T = 14.0
    }
    
    struct Header {
        static let height: T = 65.0
        
        struct Avatar {
            static let top: T = 15.0
            static let size: T = 39.0
            static let cornerRadius: T = 19.5
        }
        
        struct Nickname {
            static let left: T = 62.0
            static let top: T = 17.0
            static let fontSize: T = 16.0
            static let height: T = 20.0
        }

        static let sourceFontSize: T = 12.0
    }
    
    struct Image {
        static let verticalWidth: T = 148.0
        static let verticalHeight: T = 196.0
        
    }
    
    struct ActionButtons {
        static let height: T = 34.0
    }
    
    struct PageInfo {
        static let height: T = 70.0
    }
    
    struct Color {
        static let text = "333333"
        static let subText = "636363"
    }
    
    struct Font {
        static let text: T = 16.0
        static let subText: T = 15.0
    }
}
