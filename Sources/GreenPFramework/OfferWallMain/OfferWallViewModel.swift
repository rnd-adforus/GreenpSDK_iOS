//
//  OfferWallViewModel.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/15.
//

import UIKit

class OfferWallViewModel {
    var tabs: [SettingsData.Data.Tab] = UserInfo.shared.tabs
     
    func changePage(index: Int, completion: ([SettingsData.Data.Tab.Filter]) -> Void) {
        completion(tabs[index].filterList)
    }
}
