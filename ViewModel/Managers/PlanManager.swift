//
//  PlanManager.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import Foundation

struct Plan: Identifiable, Codable {
    var id: String = UUID().uuidString
    let plan: String
}

class PlanManager {
    
    private let storageKey = "plan_list"
    
    func savePlan(_ plan: Plan) {
        var plans = getPlans()
        plans.append(plan)
        savePlans(plans)
    }
    
    func getPlans() -> [Plan] {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let plans = try? JSONDecoder().decode([Plan].self, from: data) {
            return plans
        }
        return []
    }
    
    func deletePlan(_ id: String) {
        let plans = getPlans().filter { $0.id != id }
        savePlans(plans)
    }
    
    func savePlans(_ plans: [Plan]) {
        if let data = try? JSONEncoder().encode(plans) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
