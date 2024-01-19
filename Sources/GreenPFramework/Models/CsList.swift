//
//  File.swift
//  
//
//  Created by 신아람 on 12/22/23.
//

import Foundation

class CsListParam : Device {
    var deviceId: String?
    var sDate: String?
    var eDate: String?
    var page: Int?
    var limit: Int?
    
    private enum CodingKeys : String, CodingKey {
        case deviceid, sdate, edate, page, limit
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceId, forKey: .deviceid)
        try container.encode(sDate, forKey: .sdate)
        try container.encode(eDate, forKey: .edate)
        try container.encode(page, forKey: .page)
        try container.encode(limit, forKey: .limit)
        try super.encode(to: encoder)
    }
    
    init(page: Int?, limit: Int?) {
        self.page = page
        self.limit = limit
        self.deviceId = UserInfo.shared.uuidStr
        super.init()
        self.sDate = get30DaysAgoDate()
        self.eDate = getCurrentDate()
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        
        return dateString
    }
    
    func get30DaysAgoDate() -> String {
        let currentDate = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: currentDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDate = dateFormatter.string(from: thirtyDaysAgo)
        
        return formattedDate
    }
}

struct CsList : Decodable {
    var data: [Cs]
    
    private enum CodingKeys : String, CodingKey {
        case data
    }
    
    struct Cs : Decodable {
        var id: String
        var userId: String
        var mobile: String
        var name: String
        var content: String
        var regDate: String
        var status: String
        var answer: String
        var answerDate: String
        var adName: String?
        var iconImg: String?
        var summary: String
        var price: Int
        var priceType: String
        
        private enum CodingKeys : String, CodingKey {
            case id = "q_idx"
            case userId = "app_uid"
            case mobile = "q_mobile"
            case name = "q_name"
            case content = "q_con"
            case regDate = "q_regdate"
            case status = "q_status"
            case answer = "q_ans_con"
            case answerDate = "q_ansdate"
            case adName = "ads_name"
            case iconImg = "ads_icon_img"
            case summary = "ads_summary"
            case price = "ads_reward_price"
            case priceType = "ads_price_type"
        }
    }
}

struct CsListInfo {
    var list: [CsList.Cs] = []
    var cellConfigs: [MypageCellConfig] = []
    var currentPage: Int = 1
    var lastPageDidLoad: Bool = false
}
