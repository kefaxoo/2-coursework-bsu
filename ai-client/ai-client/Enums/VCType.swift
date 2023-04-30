//
//  VCType.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import UIKit

enum VCType: String, CaseIterable {
    case chat = "Chat"
    case settings = "Settings"
    
    var icon: UIImage? {
        switch self {
            case .chat:
                return UIImage(systemName: "message.fill")
            case .settings:
                return UIImage(systemName: "gear")
        }
    }
    
    var vc: UIViewController {
        switch self {
            case .chat:
                return ChatViewController(nibName: nil, bundle: nil)
            case .settings:
                return SettingsViewController(nibName: nil, bundle: nil)
        }
    }
}
