//
//  StoreManager.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import Foundation

struct Store: Identifiable, Codable {
    var id: String = UUID().uuidString
    let name: String
    let distance: String
    let estimatedTime: Int
}

class StoreManager {
    
    private let storageKey = "store_list"
    
    func saveStore(_ store: Store) {
        var stores = getStores()
        stores.append(store)
        saveStores(stores)
    }
    
    func getStores() -> [Store] {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let stores = try? JSONDecoder().decode([Store].self, from: data) {
            return stores
        }
        return []
    }
    
    func deleteStore(_ id: String) {
        let stores = getStores().filter { $0.id != id }
        saveStores(stores)
    }
    
    func saveStores(_ stores: [Store]) {
        if let data = try? JSONEncoder().encode(stores) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
