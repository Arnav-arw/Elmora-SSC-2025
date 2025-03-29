//
//  ContentView.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isFirstTimeLaunch") var isFirstTimeLaunch: Bool = true
    
    var body: some View {
        if isFirstTimeLaunch {
            OnboardingView()
        } else {
            TabContainerView()
        }
    }
}

#Preview {
    ContentView()
}
