//
//  ChatModel.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import Foundation

struct ChatMessage: Codable, Hashable {
    let id: String
    var content: String
    let role: SenderRole
    let type: MessageType?
    var messageCompleted: Bool
    
    init(content: String, role: SenderRole, type: MessageType? = nil) {
        self.id = UUID().uuidString
        self.content = content
        self.role = role
        self.type = type
        self.messageCompleted = false
    }
    
    init(id: String, content: String, role: SenderRole, type: MessageType? = nil) {
        self.id = id
        self.content = content
        self.role = role
        self.type = type
        self.messageCompleted = false
    }
}

enum SenderRole: String, Codable, Hashable {
    case user
    case assistant
}

enum MessageType: String, Codable, Hashable {
    // Main flows
    case goingToShop
    case goingToBed
    case goingOut
    case dialNumber
    case medicine
    
    // Helpers
    case homeCheck
    case notificationOptions
    case showOutingPlanOptions
    case showInstructions
}

