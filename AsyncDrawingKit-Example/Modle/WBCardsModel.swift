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

class WBCardModel: HandyJSON {
    
    var itemid: String?
    var scheme: String?
    var card_group: [WBCardModel]?
    var mblog: WBTimelineItem?
    
    required init() {
        
    }
    
}


class WBTimelineItem: HandyJSON {
    
    var created_at: Date?
    var mid: String?
    var idstr: String?
    var text: String = ""
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
    
    var drawingContext: WBTimelineTableViewCellDrawingContext!
    
    required init() {
        
    }
}

struct WBUser: HandyJSON {
    var idstr = ""
    var screen_name = ""
    var name = ""
    var profile_image_url = ""
    var profile_url = ""
    var domain = ""
    var avatar_large = ""
    var avatar_hd = ""
    var bi_followers_count = 0
    var lang = ""
    var star = 0
    var mbtype = 0
    var mbrank = 0
    var block_word = 0
    var block_app = 0
    var level = 0
    var type = 0
    var ulevel = 0
    var badge_top = ""
    var has_ability_tag = 0
    var nameAttributedString: NSAttributedString?
}

struct WBTimelinePicture: HandyJSON {
    
}

struct WBTimelineTitle: HandyJSON {
    var text = ""
    var base_color = 0
    var icon_url = ""
    var structs: [WBTImelineTitleStruct]?
}

struct WBTImelineTitleStruct: HandyJSON {
    var name = ""
    var scheme = ""
}

struct WBURLStruct: HandyJSON {
    var url_title = ""
    var url_type_pic = ""
    var ori_url = ""
    var page_id = ""
    var short_url = ""
    var log = ""
    var url_type = 0
    var position = 0
    var result = false
}

struct WBTimelinePageInfo: HandyJSON {
    
}
