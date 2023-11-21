//
//  SplashViewModel.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/19.
//

import UIKit

class SplashViewModel {
    var onSuccessLoadTabData: (() -> Void)?
    var tabs: [SettingsData.Data.Tab] = [] {
       didSet {
           onSuccessLoadTabData?()
       }
    }
        
    func fetchSettings() {
        guard let appCode = UserInfo.shared.appCode else {
            return
        }

        Task {
            do {
                let result: SettingsData = try await NetworkManager.shared.request(subURL: "sdk/setting.html", params: SettingParam(appCode: appCode).dictionary, method: .get)
                UserInfo.shared.settings = result.data
                tabs = result.data.tabData
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
