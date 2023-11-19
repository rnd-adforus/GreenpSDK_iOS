//
//  Font+Extensions.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit

extension UIFont {
    enum Family: String {
        case extraBold
        case bold
        case regular
        case light
        
        var shortValue: String {
            switch self {
            case .extraBold: return "EB"
            case .bold: return "B"
            case .regular: return "R"
            case .light: return "L"
            }
        }
    }
   
    static func nanumSquare(size: CGFloat, family: Family = .regular) -> UIFont {
        return UIFont(name: "NanumSquareOTF_ac\(family.shortValue)", size: size)!
    }
}
