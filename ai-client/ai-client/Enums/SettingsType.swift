//
//  SettingsType.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import Foundation

enum SettingsType: String, CaseIterable {
    case apiKey = "API Key"
    case username = "Name"
    
    var placeholder: String {
        switch self {
            case .apiKey:
                return "Enter API key here..."
            case .username:
                return "Enter name here..."
        }
    }
}
