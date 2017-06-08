//
//  WBCardsModel.swift
//  AsyncDrawingKit-Demo
//
//  Created by DSKcpp on 2017/5/27.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit
import HandyJSON

struct WBCardsModel: HandyJSON {
    
    var cards: [WBCardModel] = []

}

struct WBCardModel: HandyJSON {
    
    var itemid: String?
    var scheme: String?
    var card_group: [WBCardModel]?
    var mblog: WBTimelineItem?
}


struct WBTimelineItem: HandyJSON {
    
    var created_at: Date?
    var mid: String?
    var idstr: String?
    var text: String?
    var textLength: UInt?
    var source_allowclick: UInt?
    var source_type: UInt?
    var source: String?
    var appid: UInt?
    var favorited = false
    var truncated = false
    var pic_ids: [String] = []
    var bmiddle_pic: String?
    var original_pic: String?
    var mblogid: String?
    var user: WBUser?
    var reposts_count = 0
    var comments_count = 0
    var attitudes_count = 0
    var isLongText = false
    var retweeted_status: WBTimelineItem?
    var pic_infos: [String: WBTimelinePicture]?
    var title: WBTimelineTitle?
    var url_struct: [WBURLStruct]?
    var page_info: WBTimelinePageInfo?
}

struct WBUser: HandyJSON {
    
}

struct WBTimelinePicture: HandyJSON {
    
}

struct WBTimelineTitle: HandyJSON {
    
}

struct WBURLStruct: HandyJSON {
    
}

struct WBTimelinePageInfo: HandyJSON {
    
}
