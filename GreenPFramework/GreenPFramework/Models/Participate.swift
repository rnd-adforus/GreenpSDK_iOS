//
//  Participate.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/20.
//

import Foundation

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
