//
//  UserInfo.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation
import AdSupport
import UIKit

class UserInfo {
    static let shared: UserInfo = {
        let instance = UserInfo()
        return instance
    }()
    
    var uuidStr: String
    
    private init() {
        uuidStr = UIDevice.current.identifierForVendor?.uuidString ?? "NULL"
        settings = SettingsData.Data(listType: .list, title: "greenp", themeColor: "#2986cc", subThemeColor: "#f44336", fontColor: "#f3f6f4", subFontColor: "#ea9999", tabData: [])
    }
    
    var appCode: String? {
        get {
            return UserDefaults.standard[.appCode]
        }
        set(newAppCode) {
            if let code = newAppCode {
                UserDefaults.standard[.appCode] = code
            }
        }
    }
    
    var userID: String? {
        get {
            return UserDefaults.standard[.userID]
        }
        set(newUserID) {
            if let id = newUserID {
                UserDefaults.standard[.userID] = id
            }
        }
    }
    
    var idfa: String? {
        get {
            return UserDefaults.standard[.idfa]
        }
        set(newIDFA) {
            if let idfa = newIDFA {
                UserDefaults.standard[.idfa] = idfa
            }
        }
    }
    
    var modelStr : String {
        get {
            if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
            var sysinfo = utsname()
            uname(&sysinfo) // ignore return value
            return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        }
    }
    
    var isPermitted: Bool {
        get {
            return UserDefaults.standard[.privacyUsagePermission]
        }
        set(flag) {
            UserDefaults.standard[.privacyUsagePermission] = flag
        }
    }
    
    var settings: SettingsData.Data {
        didSet {
            tabs = settings.tabData
            filters = tabs.map{ Dictionary(uniqueKeysWithValues: $0.filterList.map{ ($0.key, $0.name) })}
            themeColor = UIColor(hex: settings.themeColor)
            subThemeColor = UIColor(hex: settings.subThemeColor)
            fontColor = UIColor(hex: settings.fontColor)
            subFontColor = UIColor(hex: settings.subFontColor)
        }
    }
    
    var tabs: [SettingsData.Data.Tab] = [] {
        didSet {
            realignmentTabs(tabs: &tabs)
        }
    }
    var filters: [Dictionary<String, String>] = [[:]] 
    
    lazy var title: String = settings.title
    lazy var themeColor: UIColor = UIColor(hex: settings.themeColor)
    lazy var subThemeColor: UIColor = UIColor(hex: settings.subThemeColor)
    lazy var fontColor: UIColor = UIColor(hex: settings.fontColor)
    lazy var subFontColor: UIColor = UIColor(hex: settings.subFontColor)
    
    private func realignmentTabs(tabs: inout [SettingsData.Data.Tab]) {
        tabs.swapAt(0, 1)
    }
}
