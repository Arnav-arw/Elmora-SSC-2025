//
//  HapticViewModel.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 13/06/24.
//

import SwiftUI

class HapticViewModel {
    
    static let shared = HapticViewModel()
    
    var isHapticOn: Bool = true
    
    func playHaptic(of type: UIImpactFeedbackGenerator.FeedbackStyle) {
        if isHapticOn {
            let impactMed = UIImpactFeedbackGenerator(style: type)
            impactMed.impactOccurred()
        }
    }
    
    func playSuccess() {
        if isHapticOn {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.success)
        }
    }
    
    func playError() {
        if isHapticOn {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.error)
        }
    }
    
    func playWarning() {
        if isHapticOn {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.warning)
        }
    }
    
    func selectionChanged() {
        if isHapticOn {
            let gen = UISelectionFeedbackGenerator()
            gen.selectionChanged()
        }
    }
    
}
