//
//  File.swift
//  
//
//  Created by 신아람 on 12/22/23.
//

import Foundation

class ParticipateListParam : Device {
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

struct ParticipateList : Decodable {
    var data: [Participate]
    
    private enum CodingKeys : String, CodingKey {
        case data
    }
    
    struct Participate : Decodable {
        var id: Int
        var name: String
        var iconURLStr: String
        var price: Int?
        var pointType: String
        var joinDay: String
        var rwdDay: String
        var rwdStatus: String
        
        private enum CodingKeys : String, CodingKey {
            case id = "ads_idx"
            case name = "ads_name"
            case iconURLStr = "ads_icon_img"
            case price = "ads_reward_price"
            case pointType = "ads_price_type"
            case joinDay = "join_day"
            case rwdDay = "rwd_day"
            case rwdStatus = "rwd_status"
        }
    }
}

struct ParticipateListInfo {
    var list: [ParticipateList.Participate] = []
    var cellConfigs: [MypageCellConfig] = []
    var currentPage: Int = 1
    var lastPageDidLoad: Bool = false
}
