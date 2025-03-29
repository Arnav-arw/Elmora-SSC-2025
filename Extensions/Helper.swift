//
//  Helper.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import Foundation
import UserNotifications

struct Helper {
    
    func getChatRecommendation() -> String {
        let suggestions = [
            "I feel like eating fruits?",
            "What medicines do I need to take today?",
            "I want to go out today",
            "I want to buy some groceries",
            "I feel sleepy",
        ]
        let suggestion = suggestions.randomElement() ?? ""
        return  "\"\(suggestion)\""
    }
    
    func formatTime(minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min\(minutes == 1 ? "" : "s")"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            
            if remainingMinutes == 0 {
                return "\(hours) hour\(hours == 1 ? "" : "s")"
            } else {
                return "\(hours) hour\(hours == 1 ? "" : "s") \(remainingMinutes) min\(remainingMinutes == 1 ? "" : "s")"
            }
        }
    }
    
    func getTimeAfterSevenHours() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        if let newTime = calendar.date(byAdding: .hour, value: 7, to: Date()) {
            return dateFormatter.string(from: newTime)
        }
        
        return "Invalid Time"
    }
    
    func scheduleNotification(title: String, subtitle: String, date: Date, isRingToneEnabled: Bool = true) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
                return
            }
            
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = subtitle
                content.sound = isRingToneEnabled ? .defaultRingtone : .default
                
                // Extracting date components
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Notification scheduled successfully!")
                    }
                }
            } else {
                print("Notification permission not granted.")
            }
        }
    }
    
}
