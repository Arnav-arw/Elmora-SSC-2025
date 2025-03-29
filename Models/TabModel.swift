//
//  TabModel.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import Foundation

enum Tabs: String, CaseIterable {
    case chat = "Chat"
    case details = "Details"
//    case profile = "Profile"
    
    var systemImage: String {
        switch self {
            case .chat:
                return "message"
            case .details:
                return "list.bullet.clipboard"
//            case .profile:
//                return "person"
        }
    }
    
    var index: Int {
        return Tabs.allCases.firstIndex(of: self) ?? 0
    }
}
