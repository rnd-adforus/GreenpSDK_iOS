//
//  FeedList.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/15.
//

import Foundation

class FeedListParam : Device {
    var category: String
    var filterKey: String?
    var orderBy: Int?
    var page: Int?
    var limit: Int?
    
    private enum CodingKeys : String, CodingKey {
        case category = "cate"
        case filterKey = "sub_cate"
        case orderBy = "orderby"
        case page, limit
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(filterKey, forKey: .filterKey)
        try container.encode(orderBy, forKey: .orderBy)
        try container.encode(page, forKey: .page)
        try container.encode(limit, forKey: .limit)
        try super.encode(to: encoder)
    }
    
    init(category: String, filterKey: String? = nil, orderBy: Int? = nil, page: Int?, limit: Int?) {
        self.category = category
        self.filterKey = filterKey
        self.orderBy = orderBy
        self.page = page
        self.limit = limit
        super.init()
    }
}

struct FeedList : Decodable {
    var reward: Int
    var data: [Feed]
    
    private enum CodingKeys : String, CodingKey {
        case reward = "tot_reward"
        case data
    }
    
    struct Feed : Decodable {
        var id: String
        var name: String
        var subTitle: String
        var summary: String
        var imageURLStr: String
        var iconURLStr: String
        var subMenuValue: String
        var reward: Int
        var category: String
        
        private enum CodingKeys : String, CodingKey {
            case id = "ads_idx"
            case name = "ads_name"
            case subTitle = "ads_brief_txt"
            case summary = "ads_summary"
            case imageURLStr = "ads_feed_img"
            case iconURLStr = "ads_icon_img"
            case subMenuValue = "ads_sub_cate"
            case reward = "ads_reward_price"
            case category = "ads_cate"
        }
    }
}
enum FeedUIType {
    case feed
    case list
}


class ParticipateParam : Device {
    var id: String
    var direct: String
    var key: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "ads_idx"
        case direct
        case key = "app_uniq_key"
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(direct, forKey: .direct)
        try container.encode(key, forKey: .key)
        try super.encode(to: encoder)
    }
    
    init(id: String, direct: String = "n") {
        self.id = id
        self.direct = direct
        self.key = "myelinsoft_uniq"
    }
}

struct ParticipateInfo : Decodable {
    var result: String
    var message: String
    var url: String
    var greenPKey: String?
    var time : Int?
    
    private enum CodingKeys : String, CodingKey {
        case result = "rst"
        case message = "msg"
        case url
        case greenPKey = "grp_key"
        case time
    }
}

class ParticipateNewsParam : Device {
    var greenPKey: String
    
    private enum CodingKeys : String, CodingKey {
        case greenPKey = "grp_key"
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(greenPKey, forKey: .greenPKey)
        try super.encode(to: encoder)
    }
    
    init(key: String) {
        self.greenPKey = key
        super.init()
    }
}
