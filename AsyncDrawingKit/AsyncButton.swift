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
    
    fileprivate var backgroundFrame = CGRect.zero
    fileprivate var imageFrame = CGRect.zero
    fileprivate var titleFrame = CGRect.zero
    
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
    
    override func draw(_ rect: CGRect, in ctx: CGContext, async: Bool) -> Bool {
        
        updateSubviewFrame()
        
        let image = buttonInfo.image
        let backgroundImage = buttonInfo.backgroundImage
        let title = buttonInfo.title
        let titleColor = buttonInfo.titleColor ?? UIColor.black
        let titleFont = buttonInfo.titleFont ?? UIFont.systemFont(ofSize: 14.0)
        
        ctx.saveGState()
        ctx.interpolationQuality = .none
        backgroundImage?.draw(in: backgroundFrame)
        image?.draw(in: imageFrame)
        if let title = title {
            let titleAttributedString = NSAttributedString(string: title, attributes: [.font : titleFont, .foregroundColor : titleColor])
            titleAttributedString.draw(in: titleFrame)
        }
        ctx.restoreGState()
        
        return true
    }
    
    public override var isEnabled: Bool {
        didSet {
            
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            updateContentsAndRelayout(false)
        }
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
                titles[key] = title
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
    
    func setImage(_ image: UIImage?, for state: UIControlState) {
        let key = stateToString(state)
        let beforeImage = images[key]
        if (image != nil || beforeImage != nil) && image != beforeImage {
            if let image = image {
                images[key] = image
            } else {
                images.removeValue(forKey: key)
            }
            if self.state == state {
                renderImage(image)
            }
        }
    }
    
    func setBackgroundImage(_ backgroundImage: UIImage, for state: UIControlState) {
        
    }
}

fileprivate extension AsyncButton {
    
    func updateContentsAndRelayout(_ relayout: Bool) {
        setNeedsDisplayMainThread()
    }
    
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
    
    func renderImage(_ image: UIImage?) {
        if (buttonInfo.image != image) {
            buttonInfo.image = image
            if buttonInfo.image != renderedImage {
                setNeedsUpdateFrame()
                setNeedsDisplay()
            }
        }
    }
    
    func updateSubviewFrame() {
        guard needsUpdateFrame else { return }
        
        backgroundFrame = bounds
        let width = bounds.width
        let height = bounds.height
        
        let imageSize = buttonInfo.image?.size ?? .zero
        let titleFont = buttonInfo.titleFont ?? UIFont.systemFont(ofSize: 14.0)
        let titleSize = buttonInfo.title?.size(with: titleFont, constrained: CGSize.init(width: width - imageSize.width, height: height), lineBreakMode: .byWordWrapping) ?? .zero
        let totalWidth = imageSize.width + titleSize.width
        let left = (width - totalWidth) / 2
        
        imageFrame = CGRect(x: left, y: (height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        titleFrame = CGRect.init(x: imageFrame.maxX, y: (height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
        needsUpdateFrame = false
    }
}

fileprivate struct AsyncButtonInfo {
    
    var title: String?
    var titleColor: UIColor?
    var titleFont: UIFont?
    var image: UIImage?
    var backgroundImage: UIImage?
}
