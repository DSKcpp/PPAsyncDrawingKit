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
    
    private lazy var titles: [UIControl.State: String] = [:]
    private lazy var titleColors: [UIControl.State: UIColor] = [:]
    private lazy var images: [UIControl.State: UIImage] = [:]
    private lazy var backgroundImages: [UIControl.State: UIImage] = [:]
    
    private let lock = Lock()
    
    private lazy var buttonInfo = AsyncButtonInfo()
    
    private var renderedTitle: String?
    private var renderedTitleColor: UIColor?
    private var renderedImage: UIImage?
    private var renderedBackgroundImage: UIImage?
    
    private var backgroundFrame = CGRect.zero
    private var imageFrame = CGRect.zero
    private var titleFrame = CGRect.zero
    
    private var needsUpdateFrame = false
    
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
    
    func title(for state: UIControl.State) -> String? {
        return titles[state]
    }
    
    func titleColor(for state: UIControl.State) -> UIColor? {
        return titleColors[state]
    }
    
    func image(for state: UIControl.State) -> UIImage? {
        return images[state]
    }
    
    func backgroundImage(for state: UIControl.State) -> UIImage? {
        return backgroundImages[state]
    }
}

public extension AsyncButton {
    
    func setTitle(_ title: String?, for state: UIControl.State) {
        let beforeTitle = titles[state]
        if (title != nil || beforeTitle != nil) && title != beforeTitle {
            if let title = title {
                titles[state] = title
            } else {
                titles.removeValue(forKey: state)
            }
            if self.state == state {
                renderTitle(title)
            }
        }
        
    }
    
    func setTitleColor(_ titleColor: UIColor, for state: UIControl.State) {
        
    }
    
    func setImage(_ image: UIImage?, for state: UIControl.State) {
        let beforeImage = images[state]
        if (image != nil || beforeImage != nil) && image != beforeImage {
            if let image = image {
                images[state] = image
            } else {
                images.removeValue(forKey: state)
            }
            if self.state == state {
                renderImage(image)
            }
        }
    }
    
    func setBackgroundImage(_ backgroundImage: UIImage, for state: UIControl.State) {
        
    }
}

private extension AsyncButton {
    
    func updateContentsAndRelayout(_ relayout: Bool) {
        setNeedsDisplayInMainThread()
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

private struct AsyncButtonInfo {
    
    var title: String?
    var titleColor: UIColor?
    var titleFont: UIFont?
    var image: UIImage?
    var backgroundImage: UIImage?
}
