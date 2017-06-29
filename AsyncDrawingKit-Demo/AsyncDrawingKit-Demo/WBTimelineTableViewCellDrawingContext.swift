//
//  WBTimelineTableViewCellDrawingContext.swift
//  AsyncDrawingKit-Demo
//
//  Created by DSKcpp on 2017/6/28.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

class WBTimelineTableViewCellDrawingContext {
    
    weak var timelineItem: WBTimelineItem!
    
    var rowHeight: CGFloat = 0.0
    var contentHeight: CGFloat = 0.0
    var contentWidth: CGFloat = 0.0
    
    var titleAttributedText: NSMutableAttributedString?
    var metaInfoAttributedText: NSMutableAttributedString?
    var textAttaibutedText: NSMutableAttributedString?
    var qoutedAttributedText: NSMutableAttributedString?
    
    var titleBackgroundViewFrame: CGRect = .zero
    var titleFrame: CGRect = .zero
    var textContentBackgroundViewFrame: CGRect = .zero
    var textFrame: CGRect = .zero
    var qoutedContentRendererFrame: CGRect = .zero
    var qoutedContentBackgroundViewFrame: CGRect = .zero
    var qoutedFrame: CGRect = .zero
    var actionButtonsViewFrame: CGRect = .zero
    var photoFrame: CGRect = .zero
    var nicknameFrame: CGRect = .zero
    var metaInfoFrame: CGRect = .zero
    var avatarFrame: CGRect = .zero
    var largeFrame: CGRect = .zero
    
    var hasPhoto: Bool {
        return false
    }
    
    var hashQouted: Bool {
        return false
    }
    
    var hasTitle: Bool {
        return false
    }
    
    var hasTitleICON: Bool {
        return false
    }
    
    init(timelineItem: WBTimelineItem) {
        self.timelineItem = timelineItem
    }
    
    func render() {
        
    }
}
