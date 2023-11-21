//
//  UserDefaults+Extensions.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit

extension UserDefaults {
    struct Key<Value> {
        let name: String
        init(_ name: String) {
            self.name = name
        }
    }
    
    subscript<V: Codable>(key: Key<V>) -> V? {
        get {
            guard let data = self.data(forKey: key.name) else {
                return nil
            }
            return try? JSONDecoder().decode(V.self, from: data)
        }
        set {
            guard let value = newValue, let data = try? JSONEncoder().encode(value) else {
                self.set(nil, forKey: key.name)
                return
            }
            self.set(data, forKey: key.name)
        }
    }
    
    subscript(key: Key<Date>) -> Date? {
        get { return self.object(forKey: key.name) as? Date }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<String>) -> String? {
        get { return self.string(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Data>) -> Data? {
        get { return self.data(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Bool>) -> Bool {
        get { return self.bool(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Int>) -> Int {
        get { return self.integer(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Float>) -> Float {
        get { return self.float(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Double>) -> Double {
        get { return self.double(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    /// UserDefault 전체를 프린트하는 함수
    func printAllUserDefaults() {
        print("--------- USER DEFAULT LIST BEGIN ----------")
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) : \(value)")
        }
        print("---------- USER DEFAULT List END -----------")
    }
}


extension UserDefaults.Key {
    typealias Key = UserDefaults.Key
    
    static var appCode: Key<String> {
        return Key<String>("USERDEFAULT_KEY_APPCODE")
    }
    static var userID: Key<String> {
        return Key<String>("USERDEFAULT_KEY_USERID")
    }
    static var idfa: Key<String> {
        return Key<String>("USERDEFAULT_KEY_IDFA")
    }
    static var privacyUsagePermission: Key<Bool> {
        return Key<Bool>("USERDEFAULT_KEY_PERMISSION_FOR_PRIVACY_USAGE")
    }
    
    static var closePopupDate: Key<Date> {
        return Key<Date>("closePopupDate")
    }
    
    static var idfaPopupShowDate: Key<Date> {
        return Key<Date>("idfaPopupShowDate")
    }
    
    static var newLocationMission: Key<Int> {
        return Key<Int>("newLocationMission")
    }
}
