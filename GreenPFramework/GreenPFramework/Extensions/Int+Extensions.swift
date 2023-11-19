//
//  Int+Extensions.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/17.
//

import Foundation

extension Int {
    /// 숫자에 comma를 추가하고 String으로 반환하는 함수
    func commaString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        return numberFormatter.string(for: self) ?? ""
    }
}
