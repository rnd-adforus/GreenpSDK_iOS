//
//  File.swift
//  
//
//  Created by 신아람 on 1/3/24.
//

import Foundation

class ParticipateListForCsParam : Device {
    var deviceId: String?
    var sDate: String?
    var eDate: String?
    
    private enum CodingKeys : String, CodingKey {
        case deviceid, sdate, edate, page, limit
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceId, forKey: .deviceid)
        try container.encode(sDate, forKey: .sdate)
        try container.encode(eDate, forKey: .edate)
        try super.encode(to: encoder)
    }
    
    override init() {
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

struct ParticipateListForCs : Decodable {
    var data: [ParticipateForCs]
    
    private enum CodingKeys : String, CodingKey {
        case data
    }
    
    struct ParticipateForCs : Decodable {
        var id: Int
        var name: String
        
        private enum CodingKeys : String, CodingKey {
            case id = "ads_idx"
            case name = "ads_name"
        }
    }
}
