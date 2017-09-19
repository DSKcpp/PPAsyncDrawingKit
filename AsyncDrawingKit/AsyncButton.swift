//
//  AsyncButton.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/9/17.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncButton: AsyncUIControl {

    lazy var titleFont = UIFont.systemFont(ofSize: 15.0)
    
    fileprivate lazy var titles: [String: String] = [:]
    fileprivate lazy var titleColors: [String: UIColor] = [:]
    fileprivate lazy var images: [String: UIImage] = [:]
    fileprivate lazy var backgroundImages: [String: UIImage] = [:]
    
    fileprivate let lock = Lock()
    
    fileprivate lazy var buttonInfo = AsyncButtonInfo()
    
    fileprivate var renderedTitle: String?
    fileprivate var renderedTitleColor: UIColor?
    fileprivate var renderedImage: UIImage?
    fileprivate var renderedBackgroundImage: UIImage?
    
    fileprivate var needsUpdateFrame = false
    
    open override var canBecomeFocused: Bool {
        return true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public extension AsyncButton {
    
    func title(for state: UIControlState) -> String? {
        let key = stateToString(state)
        return titles[key]
    }
    
    func titleColor(for state: UIControlState) -> UIColor? {
        let key = stateToString(state)
        return titleColors[key]
    }
    
    func image(for state: UIControlState) -> UIImage? {
        let key = stateToString(state)
        return images[key]
    }
    
    func backgroundImage(for state: UIControlState) -> UIImage? {
        let key = stateToString(state)
        return backgroundImages[key]
    }
}

public extension AsyncButton {
    
    func setTitle(_ title: String?, for state: UIControlState) {
        let key = stateToString(state)
        let beforeTitle = titles[key]
        if (title != nil || beforeTitle != nil) && title != beforeTitle {
            if let title = title {
                self.titles[key] = title
            } else {
                titles.removeValue(forKey: key)
            }
            if self.state == state {
                renderTitle(title)
            }
        }
        
    }
    
    func setTitleColor(_ titleColor: UIColor, for state: UIControlState) {
        
    }
    
    func setImage(_ image: UIImage, for state: UIControlState) {
        
    }
    
    func setBackgroundImage(_ backgroundImage: UIImage, for state: UIControlState) {
        
    }
}

fileprivate extension AsyncButton {
    
    func setNeedsUpdateFrame() {
        needsUpdateFrame = true
    }
    
    func renderTitle(_ title: String?) {
        if (buttonInfo.title != title) {
            buttonInfo.title = title
            if buttonInfo.title != renderedTitle {
                setNeedsUpdateFrame()
                setNeedsDisplay()
            }
        }
    }
}

fileprivate struct AsyncButtonInfo {
    
    var title: String?
    var titleColor: UIColor?
    var titleFont: UIFont?
    var image: UIImage?
    var backgroundImage: UIImage?
}
