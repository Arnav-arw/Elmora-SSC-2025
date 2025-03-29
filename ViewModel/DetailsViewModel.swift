//
//  DetailsViewModel.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import Foundation

@Observable
class DetailsViewModel {
    
    var stores: [Store] = []
    var plans: [Plan] = []
    var favouriteContacts: [Contact] = []
    var medicines: [Medicine] = []
    
    var testPrompts: [String] = [
        "I want to eat fruits",
        "I need some help",
        "I am bored, let's plan something",
        "What medicines do I need to take today?",
        "I want to buy some groceries",
        "I feel sleepy"
    ]
    
    static let shared = DetailsViewModel()
    
    let medicineManager = MedicineManager()
    let contactManager = ContactManager()
    let planManager = PlanManager()
    let storeManager = StoreManager()
    
    init() {
        fetchData()
        medicineManager.setupNotifications()
    }
    
    func fetchData() {
        medicines = medicineManager.getMedicines()
        favouriteContacts = contactManager.getContacts()
        plans = planManager.getPlans()
        stores = storeManager.getStores()
    }
    
    // MARK: MEDICINE
    func saveMedicine(_ medicine: Medicine, id: String?, isEditing: Bool) {
        if isEditing, let id {
            medicineManager.deleteMedicine(id)
        }
        medicineManager.saveMedicine(medicine)
        medicines = medicineManager.getMedicines()
        medicineManager.setupNotifications()
    }
    
    func deleteMedicine(_ id: String?) {
        guard let id else { return }
        medicineManager.deleteMedicine(id)
        medicines = medicineManager.getMedicines()
        medicineManager.setupNotifications()
    }
    
    // MARK: PLAN
    func savePlan(_ plan: Plan, id: String?, isEditing: Bool) {
        if isEditing, let id {
            planManager.deletePlan(id)
        }
        planManager.savePlan(plan)
        plans = planManager.getPlans()
    }
    
    func deletePlan(_ id: String?) {
        guard let id else { return }
        planManager.deletePlan(id)
        plans = planManager.getPlans()
    }
    
    // MARK: STORE
    func saveStore(_ store: Store, id: String?, isEditing: Bool) {
        if isEditing, let id {
            storeManager.deleteStore(id)
        }
        storeManager.saveStore(store)
        stores = storeManager.getStores()
    }
    
    func deleteStore(_ id: String?) {
        guard let id else { return }
        storeManager.deleteStore(id)
        stores = storeManager.getStores()
    }
    
    // MARK: CONTACT
    func saveContact(_ contact: Contact, id: String?, isEditing: Bool) {
        if isEditing, let id {
            contactManager.deleteContact(id)
        }
        contactManager.saveContact(contact)
        favouriteContacts = contactManager.getContacts()
    }
    
    func deleteContact(_ id: String?) {
        guard let id else { return }
        contactManager.deleteContact(id)
        favouriteContacts = contactManager.getContacts()
    }
    
}

// MARK: DUMMY DATA
extension DetailsViewModel {
    
    func isDummyDataNeeded() -> Bool {
        return stores.isEmpty && plans.isEmpty && favouriteContacts.isEmpty && medicines.isEmpty
    }
    
    func saveDummyData() {
        stores = [
            Store(name: "Kirana Store", distance: "50 m", estimatedTime: 5),
            Store(name: "Apollo Pharmacy", distance: "50 m", estimatedTime: 5),
            Store(name: "Gupta General Store", distance: "150 m", estimatedTime: 15),
            Store(name: "Local Bazaar", distance: "200 m", estimatedTime: 20),
            Store(name: "Ration Depot", distance: "300 m", estimatedTime: 25)
        ]
        plans = [
            Plan(plan: "Evening walk in the colony park"),
            Plan(plan: "Temple visit with neighbors"),
            Plan(plan: "Tea and gossip at Sharma's house"),
            Plan(plan: "Family lunch at a traditional dhaba"),
            Plan(plan: "Dinner at a new restaurant")
        ]
        favouriteContacts = [
            Contact(name: "Mom", number: "9876543210"),
            Contact(name: "Dad", number: "9123456789"),
            Contact(name: "Best Friend", number: "9988776655"),
            Contact(name: "Doctor", number: "9112233445"),
            Contact(name: "Work", number: "9001122334")
        ]
        medicines = [
            Medicine(
                name: "Paracetamol",
                dosage: "500mg",
                time: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!,
                frequency: "Daily",
                notes: "Take after food"
            ),
            Medicine(
                name: "Vitamin D",
                dosage: "1000 IU",
                time: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
                frequency: "Every other day",
                notes: nil
            ),
            Medicine(
                name: "Aspirin",
                dosage: "75mg",
                time: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!,
                frequency: "Daily",
                notes: "Take with water"
            ),
            Medicine(
                name: "Amoxicillin",
                dosage: "500mg",
                time: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!,
                frequency: "Twice a day",
                notes: "Complete full course"
            ),
            Medicine(
                name: "Metformin",
                dosage: "850mg",
                time: Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!,
                frequency: "Daily",
                notes: "Take before breakfast"
            )
        ]
        contactManager.saveContacts(favouriteContacts)
        planManager.savePlans(plans)
        storeManager.saveStores(stores)
        medicineManager.saveMedicines(medicines)
        
    }
    
}
