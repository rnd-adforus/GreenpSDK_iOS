//
//  Font+Extensions.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation
import UIKit
import CoreGraphics
import CoreText

extension UIFont {
    enum Family: String, CaseIterable {
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
        return UIFont(name: "NanumSquareOTF_ac\(family.shortValue)", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func registerAllFonts() {
        let names = UIFont.Family.allCases.map{ "NanumSquareOTF-\($0.shortValue)" }
        for name in names {
            guard let fontURL = Bundle.module.url(forResource: name, withExtension: "otf") else {
                continue
            }
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
            print(error ?? "Successfully registered font: \(name)")
        }
    }
}
