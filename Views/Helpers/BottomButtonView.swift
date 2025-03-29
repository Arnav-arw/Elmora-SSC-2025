//
//  BottomButtonView.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI

struct BottomSheetButton<Content: View, Label: View>: View {
    let content: () -> Content
    let label: () -> Label
    
    @State private var isSheetPresented = false
    
    var body: some View {
        Button(action: {
            HapticViewModel.shared.selectionChanged()
            isSheetPresented.toggle()
        }) {
            label()
        }
        .sheet(isPresented: $isSheetPresented) {
            content()
                .presentationDetents([.fraction(0.8), .large])
                .presentationDragIndicator(.visible) 
        }
    }
}

