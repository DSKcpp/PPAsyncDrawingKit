//
//  WBTimelineContentView.swift
//  AsyncDrawingKit-Demo
//
//  Created by DSKcpp on 2017/5/27.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit
import AsyncDrawingKit
import SDWebImage

final class WBTimelineContentView: UIView {
    
    let titleBackgroundView = UIView()
    let titleIcon = UIImageView()
    let contentBackgroundView = UIView()
    let contentBackgroundImageView = UIImageView()
    let nicknameLabel = AsyncTextView()
    let contentTextView = WBTimelineTextContentView()
    let avatarImageView = SDAnimatedImageView()
    let actionView = UIView()
    let photoImageView = UIView()
    
    class func height(of timelineItem: WBTimelineItem, contentWidth: CGFloat) -> CGFloat {
        let drawingContext = WBTimelineTableViewCellDrawingContext(timelineItem: timelineItem)
        timelineItem.drawingContext = drawingContext
        return drawingContext.height(contentWidth)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nicknameLabel.numberOfLines = 1
        
        addSubview(titleBackgroundView)
        addSubview(titleIcon)
        addSubview(contentBackgroundView)
        addSubview(contentBackgroundImageView)
        addSubview(nicknameLabel)
        addSubview(contentTextView)
        addSubview(avatarImageView)
        addSubview(actionView)
        addSubview(photoImageView)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var timelineItem: WBTimelineItem! {
        didSet  {
            setTimelineItem()
        }
    }
    
    private func setTimelineItem() {
        let context = timelineItem.drawingContext!
        frame = CGRect(x: 0, y: 10, width: frame.width, height: context.height)
        
        titleBackgroundView.frame = context.titleBackgroundViewFrame
        
        nicknameLabel.attributedString = timelineItem.user?.nameAttributedString
        nicknameLabel.frame = context.nicknameFrame
        
        
        contentTextView.frame = CGRect(x: 0, y: 0, width: context.width, height: context.height)
        
        actionView.frame = context.actionButtonsViewFrame
        
        avatarImageView.sd_setImage(with: URL(string: timelineItem.user!.avatar_large))
        avatarImageView.frame = context.avatarFrame
        
        
        
    }
}

