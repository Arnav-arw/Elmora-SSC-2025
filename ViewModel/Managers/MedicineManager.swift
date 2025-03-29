//
//  MedicineManager.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import Foundation
import UserNotifications

struct Medicine: Codable, Identifiable {
    var id: String { name }
    var name: String
    var dosage: String
    var time: Date
    var frequency: String
    var notes: String?
}

class MedicineManager {
    
    private let storageKey = "medicine_list"
    
    func saveMedicine(_ medicine: Medicine) {
        var medicines = getMedicines()
        medicines.append(medicine)
        saveMedicines(medicines)
        scheduleMedicineReminder(medicine)
    }
    
    func getMedicines() -> [Medicine] {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let medicines = try? JSONDecoder().decode([Medicine].self, from: data) {
            return medicines
        }
        return []
    }
    
    func deleteMedicine(_ id: String) {
        let medicines = getMedicines().filter { $0.id != id }
        saveMedicines(medicines)
    }
    
    func saveMedicines(_ medicines: [Medicine]) {
        if let data = try? JSONEncoder().encode(medicines) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    func scheduleMedicineReminder(_ medicine: Medicine) {
        let content = UNMutableNotificationContent()
        content.title = "Medicine Reminder | \(medicine.name)"
        content.body = "Time to take \(medicine.dosage) \(medicine.notes != nil ? "-" : "") \(medicine.notes ?? "")"
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.hour, .minute], from: medicine.time),
            repeats: true
        )
        
        let request = UNNotificationRequest(identifier: medicine.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelMedicineReminder(_ id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func setupNotifications() {
        let medicines = getMedicines()
        for medicine in medicines {
            cancelMedicineReminder(medicine.id)
            scheduleMedicineReminder(medicine)
        }
    }
}
