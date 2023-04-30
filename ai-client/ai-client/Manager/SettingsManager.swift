//
//  SettingsManager.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import Foundation

final class SettingsManager {
    static let shared = SettingsManager()
    
    private init() {}
    
    private var userDefaults = UserDefaults.standard
    
    var apiKey: String {
        get {
            return userDefaults.value(forKey: #function) as? String ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: #function)
        }
    }
    
    var senderId: String {
        get {
            if userDefaults.value(forKey: #function) as? String == nil {
                userDefaults.set(UUID().uuidString, forKey: #function)
            }
            
            return userDefaults.value(forKey: #function) as? String ?? ""
        }
    }
    
    var senderName: String {
        get {
            return userDefaults.value(forKey: #function) as? String ?? "User"
        }
        set {
            userDefaults.set(newValue, forKey: #function)
        }
    }
}
