//
//  MainData.swift
//
//
//  Created by 신아람 on 1/23/24.
//

import Foundation

class MainListParam : Device {
}

struct MainData : Decodable {
    var data: MainList
    
    private enum CodingKeys : String, CodingKey {
        case data
    }
    
    struct MainList : Decodable {
        var topData: [Main]
        var bandData: Main
        var rewardData: UAdReward
        
        private enum CodingKeys : String, CodingKey {
            case topData = "top_data"
            case bandData = "band_data"
            case rewardData = "uad_data"
        }
    }
    
    struct Main : Decodable {
        var id: String
        var name: String
        var cate: String
        var iconURLStr: String
        var price: Int
        var pointType: String
        var briefText: String
        var summary: String
        
        private enum CodingKeys : String, CodingKey {
            case id = "ads_idx"
            case name = "ads_name"
            case cate = "ads_cate"
            case iconURLStr = "ads_img"
            case price = "ads_reward_price"
            case pointType = "ads_price_type"
            case briefText = "ads_brief_txt"
            case summary = "ads_summary"
        }
    }
    
    struct UAdReward : Decodable {
        var iconURLStr: String
        private enum CodingKeys : String, CodingKey {
            case iconURLStr = "ads_img"
        }
    }
}

struct MainListInfo {
    var list: [MainData.Main] = []
    var cellConfigs: [FeedCellConfig] = []
}
