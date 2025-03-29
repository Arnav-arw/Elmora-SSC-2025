//
//  StoreFormView.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI

struct StoreFormView: View {
    
    @State var store: Store?
    @State var name: String = ""
    @State var distance: String = ""
    @State var estimatedTime: String = ""
    
    @State var isEditing: Bool
    
    @State var detailsVM = DetailsViewModel.shared
    
    @Environment(\.dismiss) var dismiss
    
    init(store: Store? = nil) {
        self._store = State(initialValue: store)
        self._isEditing = State(initialValue: store != nil)
        
        if let store = store {
            self._name = State(initialValue: store.name)
            self._distance = State(initialValue: store.distance)
            self._estimatedTime = State(initialValue: "\(store.estimatedTime)")
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Store Name", text: $name)
                    TextField("Distance", text: $distance)
                    TextField("Estimated Time (minutes)", text: $estimatedTime)
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    if isEditing {
                        Button {
                            HapticViewModel.shared.playWarning()
                            detailsVM.deleteStore(store?.id)
                        } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                                .padding(.all, 15)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(.circle)
                        }
                    }
                    Button(action: saveStore) {
                        Text(isEditing ? "Update Store" : "Add Store")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.all, 15)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(.capsule)
                    }
                    .buttonStyle(PushDownButtonStyle())
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle(isEditing ? "Edit Store" : "Add Store")
            .navigationBarTitleDisplayMode(isEditing ? .large : .inline)
        }
    }

    private func saveStore() {
        HapticViewModel.shared.playSuccess()
        guard let estimatedTimeInt = Int(estimatedTime) else { return }
        
        let newStore = Store(
            name: name,
            distance: distance,
            estimatedTime: estimatedTimeInt
        )
        detailsVM.saveStore(newStore, id: store?.id, isEditing: isEditing)
        dismiss()
    }
}
