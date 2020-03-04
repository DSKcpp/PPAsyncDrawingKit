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
    
    var height: CGFloat = 0.0
    var width: CGFloat = 0.0
    
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
    
    var hasQouted: Bool {
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
        
        let content = timelineItem.text
        
        NSString *itemText = timelineItem.text;
        WBTimelineAttributedTextParser *parser = [WBTimelineAttributedTextParser textParserWithTimelineItem:timelineItem];
        WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
        if (itemText) {
            _textAttributedText = [[NSMutableAttributedString alloc] initWithString:itemText];
            [parser parserWithAttributedString:_textAttributedText
                                      fontSize:preset.textFont
                                     textColor:[UIColor colorWithHexString:preset.textColor]];
        }
        if (timelineItem.retweeted_status) {
            NSString *quotedItemText;
            if (timelineItem.retweeted_status.user.screen_name) {
                quotedItemText = [NSString stringWithFormat:@"@%@:%@", timelineItem.retweeted_status.user.screen_name, timelineItem.retweeted_status.text];
            } else {
                quotedItemText = timelineItem.retweeted_status.text;
            }
            if (quotedItemText.length > 0) {
                _quotedAttributedText = [[NSMutableAttributedString alloc] initWithString:quotedItemText];
                [parser parserWithAttributedString:_quotedAttributedText
                                          fontSize:preset.subtextFont
                                         textColor:[UIColor colorWithHexString:preset.subtextColor]];
            }
        }
        if (timelineItem.title) {
            NSString *title = timelineItem.title.text;
            _titleAttributedText = [[NSMutableAttributedString alloc] initWithString:title];
            [_titleAttributedText pp_setFont:[UIFont systemFontOfSize:preset.subtextFont]];
            [_titleAttributedText pp_setColor:[UIColor colorWithHexString:preset.textColor]];
        }
        _metaInfoAttributedText = [self source];
        timelineItem.user.nameAttributedString = [self name];
    }
    
    func height(_ width: CGFloat) -> CGFloat {
        self.width = width
        render()
        return height
    }
    
    private func render() {
        let maxWidth = width - Preset.Common.spacing * 2
        var totalHeight: CGFloat = 0.0
        
        if hasTitle {
            titleBackgroundViewFrame = CGRect(x: 0, y: 0, width: width, height: Preset.Title.height)
            let height = titleAttributedText!.heightConstrained(toWidth: maxWidth)
            var titleRect = CGRect(x: Preset.Title.iconLeft + Preset.Title.iconSize + 5.0, y: 0, width: maxWidth, height: height)
            titleRect.origin.y = (Preset.Title.height - height) / 2.0
            titleFrame = titleRect
            totalHeight += Preset.Title.height
        }
        
        let titleHeight = hasTitle ? Preset.Title.height : 0
        avatarFrame = CGRect(x: Preset.Common.spacing,
                             y: Preset.Header.Avatar.top + titleHeight,
                             width: Preset.Header.Avatar.size, height: Preset.Header.Avatar.size)
        
        let nicknameMaxWidth = maxWidth - Preset.Header.Avatar.size - Preset.Common.spacing * 2.0
        nicknameFrame = CGRect(x: Preset.Header.Nickname.left,
                               y: totalHeight + Preset.Header.Nickname.top,
                               width: nicknameMaxWidth,
                               height: Preset.Header.Nickname.height)
        metaInfoFrame = CGRect(x: nicknameFrame.minX,
                               y: nicknameFrame.maxY + 10,
                               width: nicknameFrame.width,
                               height: nicknameFrame.height)
        
        totalHeight += Preset.Header.height
        
        let numberOfLines = timelineItem.isLongText ? Preset.Common.numberOfLines : 0
        let height = textAttaibutedText?.sizeConstrained(toWidth: maxWidth, numberOfLines: numberOfLines).height ?? 0
        textFrame = CGRect(x: Preset.Common.spacing, y: totalHeight, width: maxWidth, height: height)
        totalHeight += height
        
        if hasQouted {
            var qoutedHeight: CGFloat = 0
            let numberOfLines = timelineItem.retweeted_status!.isLongText ? Preset.Common.numberOfLines : 0
            let height = qoutedAttributedText!.sizeConstrained(toWidth: maxWidth, numberOfLines: numberOfLines).height
            qoutedFrame = CGRect(x: Preset.Common.spacing, y: textFrame.maxY + Preset.Common.margin, width: maxWidth, height: height)
            qoutedHeight += height + Preset.Common.margin
            totalHeight += height + Preset.Common.margin
            
            let picCount = timelineItem.retweeted_status!.pic_infos?.count ?? 0
            if picCount == 1 {
                photoFrame = CGRect(x: Preset.Common.spacing,
                                    y: totalHeight + Preset.Common.margin,
                                    width: Preset.Image.verticalWidth,
                                    height: Preset.Image.verticalHeight)
                qoutedHeight += photoFrame.height + Preset.Common.margin * 2.0
                totalHeight += photoFrame.height + Preset.Common.margin * 2.0
            } else if picCount > 1 {
                let rows = (CGFloat(picCount)/3.0).rounded(.up)
                let height = rows * 88.0
                photoFrame = CGRect(x: Preset.Common.spacing,
                                    y: totalHeight + Preset.Common.margin,
                                    width: maxWidth,
                                    height: height)
                qoutedHeight += photoFrame.height + Preset.Common.margin * 2.0
                totalHeight += photoFrame.height + Preset.Common.margin * 2.0
            }
            qoutedContentBackgroundViewFrame = CGRect(x: 0, y: qoutedFrame.minY - 5.0, width: width, height: qoutedHeight + 5.0)
        } else {
            let picCount = timelineItem.pic_infos?.count ?? 0
            if picCount == 0 {
                totalHeight += Preset.Common.margin
            } else if picCount == 1 {
                photoFrame = CGRect(x: Preset.Common.spacing,
                                                   y: totalHeight + Preset.Common.margin,
                                                   width: Preset.Image.verticalWidth,
                                                   height: Preset.Image.verticalHeight)

                totalHeight += photoFrame.height + Preset.Common.margin * 2.0
            } else {
                let rows = (CGFloat(picCount)/3.0).rounded(.up)
                let height = rows * 88.0
                photoFrame = CGRect(x: Preset.Common.spacing,
                                    y: totalHeight + Preset.Common.margin,
                                    width: maxWidth,
                                    height: height)
                totalHeight += photoFrame.height + Preset.Common.margin * 2.0
            }
        }
        
        if let pageInfo = timelineItem.page_info {
            if hasQouted {
                qoutedContentBackgroundViewFrame.size.height += Preset.PageInfo.height
            }
            largeFrame = CGRect(x: Preset.Common.spacing, y: totalHeight, width: maxWidth, height: Preset.PageInfo.height)
            totalHeight += largeFrame.height + Preset.Common.margin
        }

        textContentBackgroundViewFrame = CGRect(x: 0, y: titleHeight, width: width, height: totalHeight - titleHeight)
        actionButtonsViewFrame = CGRect(x:0, y:textContentBackgroundViewFrame.maxY, width: width, height: Preset.ActionButtons.height)
        
        totalHeight += actionButtonsViewFrame.height + Preset.Common.margin
        
        self.height = max(totalHeight, Preset.Common.minHeight)
    }
}
