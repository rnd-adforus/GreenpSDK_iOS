//
//  File.swift
//  
//
//  Created by 신아람 on 1/5/24.
//

import Foundation

class SendCsParam : Device {
    var deviceId: String
    var id: String
    var content: String
    var mobile: String
    var email: String
    var name: String
    var file: URL?
    
    private enum CodingKeys : String, CodingKey {
        case deviceid = "deviceid"
        case id = "ads_idx"
        case content = "q_con"
        case mobile = "q_mobile"
        case email = "q_email"
        case name = "q_name"
        case file = "q_file"
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceId, forKey: .deviceid)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(mobile, forKey: .mobile)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(file, forKey: .file)
        try super.encode(to: encoder)
    }
    
    init(id: String, content: String, mobile: String, email: String, name: String, file: URL?) {
        self.deviceId = UserInfo.shared.uuidStr
        self.id = id
        self.content = content
        self.mobile = mobile
        self.email = email
        self.name = name
        self.file = file
        super.init()
    }
}
