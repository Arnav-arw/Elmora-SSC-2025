//
//  ContactManager.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import Foundation

struct Contact: Identifiable, Codable {
    var id: String = UUID().uuidString
    let name: String
    let number: String
}

class ContactManager {
    
    private let storageKey = "contact_list"

    func saveContact(_ contact: Contact) {
        var contacts = getContacts()
        contacts.append(contact)
        saveContacts(contacts)
    }
    
    func getContacts() -> [Contact] {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let contacts = try? JSONDecoder().decode([Contact].self, from: data) {
            return contacts
        }
        return []
    }
    
    func deleteContact(_ id: String) {
        let contacts = getContacts().filter { $0.id != id }
        saveContacts(contacts)
    }
    
    func saveContacts(_ contacts: [Contact]) {
        if let data = try? JSONEncoder().encode(contacts) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
