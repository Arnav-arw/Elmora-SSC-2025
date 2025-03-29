//
//  MedicineView.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI

struct MedicineFormView: View {
    
    @State var medicine: Medicine?
    @State var name: String = ""
    @State var dosage: String = ""
    @State var time: Date = Date()
    @State var frequency: String = ""
    @State var notes: String = ""
    
    @State var isEditing: Bool
    
    @State var detailsVM = DetailsViewModel.shared
    
    @State var deleteMedicine: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    init(medicine: Medicine? = nil) {
        self._medicine = State(initialValue: medicine)
        self._isEditing = State(initialValue: medicine != nil)
        
        if let medicine = medicine {
            self._name = State(initialValue: medicine.name)
            self._dosage = State(initialValue: medicine.dosage)
            self._time = State(initialValue: medicine.time)
            self._frequency = State(initialValue: medicine.frequency)
            self._notes = State(initialValue: medicine.notes ?? "")
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Medicine Name", text: $name)
                    TextField("Dosage", text: $dosage)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    TextField("Frequency", text: $frequency)
                    TextField("Notes", text: $notes)
                }
                HStack {
                    if isEditing {
                        Button {
                            withAnimation(.bouncy(duration: 1)) {
                                deleteMedicine.toggle()
                            }
                            HapticViewModel.shared.playWarning()
                            detailsVM.deleteMedicine(medicine?.id)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                                .padding(.all, deleteMedicine ? 10000 : 15)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(.circle)
                        }
                    }
                    Button(action: saveMedicine) {
                        Text(isEditing ? "Update Medicine" : "Add Medicine")
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
            .navigationTitle(isEditing ? "Edit Medicine" : "Add Medicine")
            .navigationBarTitleDisplayMode(isEditing ? .large : .inline)
        }
    }

    private func saveMedicine() {
        HapticViewModel.shared.playSuccess()
        let newMedicine = Medicine(
            name: name,
            dosage: dosage,
            time: time,
            frequency: frequency,
            notes: notes.isEmpty ? nil : notes
        )
        detailsVM.saveMedicine(newMedicine, id: medicine?.id, isEditing: isEditing)
        dismiss()
    }
}
