//
//  APIResult.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation

class APIResult : Decodable {
    var result: String
    var message: String
    
    private enum CodingKeys : String, CodingKey {
        case result = "rst"
        case message = "msg"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decode(String.self, forKey: .result)
        message = try values.decode(String.self, forKey: .message)
    }
}
