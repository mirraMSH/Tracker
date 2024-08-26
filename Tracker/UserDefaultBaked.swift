//
//  UserDefaultBaked.swift
//  Tracker
//
//  Created by Мария Шагина on 26.08.2024.
//

import Foundation

// TODO:
@propertyWrapper
struct UserDefaultsBacked<Value> {
    let key: String
    let storage: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get {
            storage.value(forKey: key) as? Value
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
}
