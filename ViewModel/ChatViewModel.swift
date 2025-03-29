//
//  ChatViewModel.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import Foundation
import SwiftUI

@Observable
class ChatViewModel {
    
    var messages: [ChatMessage] = []
    private var selectedStore: Store?
    private let helpers = Helper()
    private var lastAssistantMessageType: MessageType?
    
    func processResponse(with input: String) {
        messages.append(ChatMessage(content: input, role: .user))
        let lowerCasedInput = input.lowercased()
        
        if checkConfirmation(lowerCasedInput) {
            handleConfirmation()
            return
        }
        
        if checkThanks(lowerCasedInput) || checkNoThanks(lowerCasedInput) {
            handleThanks()
            return
        }
        
        if isMedicineRelated(input: lowerCasedInput) {
            lastAssistantMessageType = .medicine
            let message = ChatMessage(content: "Here are your today's medication list:", role: .assistant, type: .medicine)
            messages.append(message)
            startTypingAnimation(for: message)
            let message2 = ChatMessage(content: "Don't worry, I'll remind you to take them.", role: .assistant)
            messages.append(message2)
            startTypingAnimation(for: message2)
        } else if checkHome(input: lowerCasedInput) {
            lastAssistantMessageType = .homeCheck
            let message = ChatMessage(content: "Do you already have it at home?", role: .assistant, type: .homeCheck)
            messages.append(message)
            startTypingAnimation(for: message)
        } else if isGoingToShop(input: lowerCasedInput) {
            lastAssistantMessageType = .goingToShop
            let message = ChatMessage(content: "Sure, which store do you want to go?", role: .assistant, type: .goingToShop)
            messages.append(message)
            startTypingAnimation(for: message)
        } else if isPlanningOuting(input: lowerCasedInput) {
            lastAssistantMessageType = .goingOut
            let message = ChatMessage(content: "Do you want me to check your calendar and suggest plans?", role: .assistant, type: .goingOut)
            messages.append(message)
            startTypingAnimation(for: message)
        } else if isPlanningToSleep(input: lowerCasedInput) {
            lastAssistantMessageType = .goingToBed
            let message = ChatMessage(content: "Of course! Would you like me to set an alarm for a full 7 hours of sleep?", role: .assistant, type: .goingToBed)
            messages.append(message)
            startTypingAnimation(for: message)
        } else if isDialingNumber(input: lowerCasedInput) {
            lastAssistantMessageType = .dialNumber
            let message = ChatMessage(content: "Would you like me to call your favorite contact?", role: .assistant, type: .dialNumber)
            messages.append(message)
            startTypingAnimation(for: message)
        } else if isGreeting(input: lowerCasedInput) {
            let message = ChatMessage(content: "Hey there! How can I assist you today?", role: .assistant)
            messages.append(message)
            startTypingAnimation(for: message)
        } else {
            let message = ChatMessage(content: "Sorry, currently I can't assist you with that.", role: .assistant, type: .showInstructions)
            messages.append(message)
            startTypingAnimation(for: message)
        }
    }
    
    func startTypingAnimation(for message: ChatMessage) {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else { return }
        
        var currentText = ""
        let originalText = message.content
        var charIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if charIndex < originalText.count {
                let char = originalText[originalText.index(originalText.startIndex, offsetBy: charIndex)]
                currentText.append(char)
                self.messages[index].content = currentText
                charIndex += 1
            } else {
                timer.invalidate()
                withAnimation {
                    self.messages[index].messageCompleted = true
                }
            }
        }
    }
}

// MARK: CHECKS FOR MESSAGES
private extension ChatViewModel {
    
    func checkConfirmation(_ input: String) -> Bool {
        return input.contains("yes") || input.contains("sure")
    }
    
    func checkNoThanks(_ input: String) -> Bool {
        return input.contains("no") || input.contains("nope")
    }
    
    func checkThanks(_ input: String) -> Bool {
        return input.contains("thanks") || input.contains("thank you")
    }
    
    func isGoingToShop(input: String) -> Bool {
        return input.contains("buy") || input.contains("store") || input.contains("grocery")
    }
    
    func checkHome(input: String) -> Bool {
        return input.contains("grocery") || input.contains("medicine") || input.contains("fruits") || input.contains("vegetables")
    }
    
    func isPlanningOuting(input: String) -> Bool {
        return input.contains("go out") || input.contains("party") || input.contains("meet friends") || input.contains("dinner") || input.contains("plan")
    }
    
    func isPlanningToSleep(input: String) -> Bool {
        return input.contains("sleep") || input.contains("bed") || input.contains("night") || input.contains("sleepy")
    }
    
    func isDialingNumber(input: String) -> Bool {
        return input.contains("call") || input.contains("dial") || input.contains("phone") || input.contains("help") || input.contains("i need someone") || input.contains("assistance")
    }
    
    func isMedicineRelated(input: String) -> Bool {
        return (input.contains("medicine") || input.contains("medicines")) && (input.contains("today") || input.contains("today's"))
    }
    
    func isGreeting(input: String) -> Bool {
        return (input.contains("hi") || input.contains("hey") || input.contains("hello"))
    }
}

// MARK: HANDLING RESPONSE FROM CHAT
extension ChatViewModel {
    
    func handleGoingToShopResponse(with store: Store) {
        let message = ChatMessage(content: "Sure, it will take \(helpers.formatTime(minutes: store.estimatedTime)), do you want me to remind you once it's done?", role: .assistant, type: .notificationOptions)
        selectedStore = store
        messages.append(message)
        startTypingAnimation(for: message)
    }
    
    func handlePantryCheck(with isItemFound: Bool) {
        if isItemFound {
            let message = ChatMessage(content: "That's great!, let me know if I could help in something else", role: .assistant)
            messages.append(message)
            startTypingAnimation(for: message)
            lastAssistantMessageType = nil
        } else {
            let message = ChatMessage(content: "Oh no issues, you can checkout from any of the stores below.", role: .assistant, type: .goingToShop)
            messages.append(message)
            startTypingAnimation(for: message)
            lastAssistantMessageType = .goingToShop
        }
    }
    
    func handleOutingPlanSuggestionCheck(with isPlanWanted: Bool) {
        if isPlanWanted {
            checkCalendarAndSuggestPlans()
        } else {
            let message = ChatMessage(content: "Sure thing! Let me know if I could help in something else", role: .assistant)
            messages.append(message)
            startTypingAnimation(for: message)
            lastAssistantMessageType = nil
        }
    }
    
    func handleSleep(with isAlarmOn: Bool, isUsualTime: Bool) {
        if isAlarmOn && !isUsualTime {
            let message = ChatMessage(content: "Sure, will set the alarm for \(helpers.getTimeAfterSevenHours()). Good night!", role: .assistant)
            messages.append(message)
            startTypingAnimation(for: message)
            lastAssistantMessageType = nil
            if let targetDate = Calendar.current.date(byAdding: .hour, value: 7, to: Date()) {
                helpers.scheduleNotification(title: "Good Morning!", subtitle: "Wakey Wakey it's time to wake up!", date: targetDate)
            }
        } else if isAlarmOn && isUsualTime {
            let message = ChatMessage(content: "Sure, will set the alarm for your usual time. Good night!", role: .assistant)
            messages.append(message)
            startTypingAnimation(for: message)
            if let targetDate = Calendar.current.date(from: .init(timeZone: .current, hour: 7, minute: 0, second: 0)) {
                helpers.scheduleNotification(title: "Good Morning!", subtitle: "Wakey Wakey it's time to wake up!", date: targetDate)
            }
            lastAssistantMessageType = nil
        } else if !isAlarmOn {
            let message = ChatMessage(content: "Sure, have a great sleep. Good night!", role: .assistant)
            messages.append(message)
            startTypingAnimation(for: message)
            lastAssistantMessageType = nil
        }
    }
    
   
    func handleCalling(_ number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func handleNotificationOption(_ isSelected: Bool) {
        if isSelected {
            let message = ChatMessage(content: "Great! I will remind for you.", role: .assistant)
            messages.append(message)
            startTypingAnimation(for: message)
            if let selectedStore {
                if let targetDate = Calendar.current.date(byAdding: .minute, value: selectedStore.estimatedTime, to: Date()) {
                    helpers.scheduleNotification(title: "Hey there!", subtitle: "Did you reach home safely?", date: targetDate)
                }
                self.selectedStore = nil
            }
        } else {
            let message = ChatMessage(content: "Sure! No problem.", role: .assistant)
            messages.append(message)
            startTypingAnimation(for: message)
        }
    }
    
    private func handleConfirmation() {
        guard let lastType = lastAssistantMessageType else { return }
        
        switch lastType {
            case .goingToShop:
                askForPreferredStore()
            case .notificationOptions:
                confirmReminderSetup()
            case .goingOut:
                checkCalendarAndSuggestPlans()
            default:
                break
        }
        
        lastAssistantMessageType = nil
    }
    
    private func handleThanks() {
        let message = ChatMessage(content: "No problem!, I'm here to help.", role: .assistant)
        messages.append(message)
        startTypingAnimation(for: message)
        
        lastAssistantMessageType = nil
    }
    
    private func askForPreferredStore() {
        let message = ChatMessage(content: "Please select your preferred store.", role: .assistant)
        messages.append(message)
        startTypingAnimation(for: message)
    }
    
    private func confirmReminderSetup() {
        let message = ChatMessage(content: "Great! I will remind you.", role: .assistant)
        messages.append(message)
        startTypingAnimation(for: message)
    }
    
    private func checkCalendarAndSuggestPlans() {
        let message = ChatMessage(content: "Great your calendar is clear for the day... Here are some suggestions:", role: .assistant, type: .showOutingPlanOptions)
        messages.append(message)
        startTypingAnimation(for: message)
        lastAssistantMessageType = .showOutingPlanOptions
    }
}
