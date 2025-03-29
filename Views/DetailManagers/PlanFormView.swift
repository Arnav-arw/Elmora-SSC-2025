//
//  PlanFormView.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI

struct PlanFormView: View {
    
    @State var plan: Plan?
    @State var planText: String = ""
    
    @State var isEditing: Bool
    
    @State var detailsVM = DetailsViewModel.shared
    
    @Environment(\.dismiss) var dismiss
    
    init(plan: Plan? = nil) {
        self._plan = State(initialValue: plan)
        self._isEditing = State(initialValue: plan != nil)
        
        if let plan = plan {
            self._planText = State(initialValue: plan.plan)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Plan Details", text: $planText, axis: .vertical)
                }
                HStack {
                    if isEditing {
                        Button {
                            HapticViewModel.shared.playWarning()
                            detailsVM.deletePlan(plan?.id)
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
                    Button(action: savePlan) {
                        Text(isEditing ? "Update Plan" : "Add Plan")
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
            .navigationTitle(isEditing ? "Edit Plan" : "Add Plan")
            .navigationBarTitleDisplayMode(isEditing ? .large : .inline)
        }
    }

    private func savePlan() {
        HapticViewModel.shared.playSuccess()
        let newPlan = Plan(plan: planText)
        detailsVM.savePlan(newPlan, id: plan?.id, isEditing: isEditing)
        dismiss()
    }
}
