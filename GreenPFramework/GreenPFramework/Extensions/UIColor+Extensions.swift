//
//  UIColor+Extensions.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/17.
//

import UIKit

extension UIColor {
    static func RGB(_ sameFloat: CGFloat, alpha: CGFloat = 1) -> UIColor {
        let color = UIColor(red: sameFloat/255, green: sameFloat/255, blue: sameFloat/255, alpha: alpha)
        return color
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hex: String?) {
        guard let hex = hex else {
            self.init(rgb: 0xFFFFFF)
            return
        }
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init(rgb: 0xFFFFFF)
        }

        var rgb: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgb)

        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
