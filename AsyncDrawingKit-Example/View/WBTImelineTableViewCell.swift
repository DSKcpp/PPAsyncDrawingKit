//
//  WBTImelineTableViewCell.swift
//  AsyncDrawingKit-Demo
//
//  Created by DSKcpp on 2017/5/26.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

final class WBTImelineTableViewCell: UITableViewCell {

    var timelineItem: WBTimelineItem {
        get {
            return timelineContentView.timelineItem
        } set {
            timelineContentView.timelineItem = newValue
        }
    }
    
    let timelineContentView = WBTimelineContentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timelineContentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
