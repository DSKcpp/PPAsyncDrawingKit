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
        static let titleAreaHeight: T = 34.0
        static let titleIconTop: T = 9.5
        static let titleIconLeft: T = 11.0
        static let titleIconSize: T = 15.0
        static let titleFontSize: T = 14.0
    }
    
    struct Header {
        static let headerAreaHeight: T = 65.0
        
        struct Avatar {
            static let avatarTop: T = 15.0
            static let avatatSize: T = 39.0
            static let avatarCornerRadius: T = 19.5
        }
        
        struct Nickname {
            static let nicknameLeft: T = 62.0
            static let nicknameTop: T = 17.0
            static let nicknameFontSize: T = 16.0
        }

        static let sourceFontSize: T = 12.0
    }
    
    struct Image {
        
    }
    
    struct ActionButtons {
        
    }
    
    struct PageInfo {
        
    }
    
    struct Color {
        
    }
    
    struct Font {
        
    }
}
