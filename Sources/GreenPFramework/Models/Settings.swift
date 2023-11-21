//
//  Settings.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation

class Device : Encodable {
    var appCode: String
    var userID: String
    var idfa: String
    var uuid: String
    
    private enum CodingKeys : String, CodingKey {
        case appCode = "appcode"
        case userID = "app_uid"
        case idfa
        case uuid = "deviceid"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appCode, forKey: .appCode)
        try container.encode(userID, forKey: .userID)
        try container.encode(idfa, forKey: .idfa)
        try container.encode(uuid, forKey: .uuid)
    }
    
    init() {
        self.appCode = UserInfo.shared.appCode ?? ""
        self.userID = UserInfo.shared.userID ?? ""
        self.idfa = UserInfo.shared.idfa ?? ""
        self.uuid = UserInfo.shared.uuidStr
    }
}

class DeviceRegistParam : Device {
    var model: String
    var brand: String = "apple"

    private enum CodingKeys : String, CodingKey {
        case model, brand
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(brand, forKey: .brand)
        try super.encode(to: encoder)
    }
    
    override init() {
        self.model = UserInfo.shared.modelStr
    }
}

struct SettingParam : Encodable {
    var appCode: String
    
    private enum CodingKeys : String, CodingKey {
        case appCode = "appcode"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appCode, forKey: .appCode)
    }
}

struct SettingsData : Decodable {
    var data: Data
    
    struct Data : Decodable {
        var listType: ListType
        var themeColor: String
        var subThemeColor: String
        var fontColor: String
        var subFontColor: String
        
        var tabData: [Tab]
        
        private enum CodingKeys : String, CodingKey {
            case listType = "list_type"
            case themeColor = "color"
            case subThemeColor = "small_bg_color"
            case fontColor = "font_color"
            case subFontColor = "small_font_color"
            
            case tabData = "cate_order"
        }
        
        enum ListType : String, Decodable {
            case list = "L"
            case feed = "F"
        }
        
        struct Tab : Decodable {
            var key: String
            var name: String
            var filterList: [Filter]
            
            private enum CodingKeys : String, CodingKey {
                case key, name
                case filterList = "filter_list"
            }
            
            struct Filter : Decodable {
                var key: String
                var name: String
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                key = try values.decode(String.self, forKey: .key)
                name = try values.decode(String.self, forKey: .name)
                filterList = try values.decode([Filter].self, forKey: .filterList).filter{ $0.key != "20" }
            }
        }
    }
}
