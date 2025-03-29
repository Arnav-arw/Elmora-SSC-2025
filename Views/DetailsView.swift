//
//  DetailsView.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import SwiftUI

struct DetailsView: View {
    
    @State var detailsVM = DetailsViewModel.shared
    @State var showDummyDataAlert: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                
                if showDummyDataAlert && detailsVM.isDummyDataNeeded() {
                    Button {
                        detailsVM.saveDummyData()
                        showDummyDataAlert = false
                    } label: {
                        Label("Just trying it out? Add dummy data", systemImage: "swiftdata")
                    }
                }
                
                Section("Medicines") {
                    ForEach(detailsVM.medicines) { medicine in
                        NavigationLink {
                            MedicineFormView(medicine: medicine)
                        } label: {
                            Text("\(medicine.name) | \(medicine.frequency)")
                                .swipeActions {
                                    Button(role: .destructive) {
                                        HapticViewModel.shared.playWarning()
                                        detailsVM.deleteMedicine(medicine.id)
                                   } label: {
                                       Label("Delete", systemImage: "trash")
                                   }
                                }
                        }
                    }
                    BottomSheetButton {
                        MedicineFormView(medicine: nil)
                    } label: {
                        Text("Add Medicine")
                            .foregroundStyle(.blue)
                    }
                }
                
                Section("Contacts") {
                    ForEach(detailsVM.favouriteContacts) { contact in
                        NavigationLink {
                            ContactFormView(contact: contact)
                        } label: {
                            Text(contact.name)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        HapticViewModel.shared.playWarning()
                                        detailsVM.deleteContact(contact.id)
                                   } label: {
                                       Label("Delete", systemImage: "trash")
                                   }
                                }
                        }
                    }
                    BottomSheetButton {
                        ContactFormView(contact: nil)
                    } label: {
                        Text("Add Contact")
                            .foregroundStyle(.blue)
                    }
                }
                
                Section("Stores") {
                    ForEach(detailsVM.stores) { store in
                        NavigationLink {
                            StoreFormView(store: store)
                        } label: {
                            Text(store.name)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        HapticViewModel.shared.playWarning()
                                        detailsVM.deleteStore(store.id)
                                   } label: {
                                       Label("Delete", systemImage: "trash")
                                   }
                                }
                        }
                    }
                    BottomSheetButton {
                        StoreFormView()
                    } label: {
                        Text("Add Store")
                            .foregroundStyle(.blue)
                    }
                }
                
                Section("Plans") {
                    ForEach(detailsVM.plans) { plan in
                        NavigationLink {
                            PlanFormView(plan: plan)
                        } label: {
                            Text(plan.plan)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        HapticViewModel.shared.playWarning()
                                        detailsVM.deletePlan(plan.id)
                                   } label: {
                                       Label("Delete", systemImage: "trash")
                                   }
                                }
                        }
                    }
                    BottomSheetButton {
                        PlanFormView(plan: nil)
                    } label: {
                        Text("Add Plan")
                            .foregroundStyle(.blue)
                    }
                }
                
                Color(.clear)
                   .frame(height: 100)
                   .listRowBackground(Color.clear)
            }
        }
    }
}

#Preview {
    DetailsView()
}
