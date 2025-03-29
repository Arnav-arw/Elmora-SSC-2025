//
//  ContactFormView.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI
import ContactsUI

struct ContactFormView: View {
    
    @State var contact: Contact?
    @State var name: String = ""
    @State var number: String = ""
    
    @State var isEditing: Bool
    @State var showContactPicker: Bool = false
    
    @State var detailsVM = DetailsViewModel.shared
    
    @Environment(\.dismiss) var dismiss
    
    init(contact: Contact? = nil) {
        self._contact = State(initialValue: contact)
        self._isEditing = State(initialValue: contact != nil)
        
        if let contact = contact {
            self._name = State(initialValue: contact.name)
            self._number = State(initialValue: contact.number)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Contact Name", text: $name)
                    TextField("Phone Number", text: $number)
                        .keyboardType(.phonePad)
                    
                    Button {
                        showContactPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Pick from Contacts")
                        }
                    }
                }
                
                HStack {
                    if isEditing {
                        Button {
                            HapticViewModel.shared.playWarning()
                            detailsVM.deleteContact(contact?.id)
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
                    Button(action: saveContact) {
                        Text(isEditing ? "Update Contact" : "Add Contact")
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
            .navigationTitle(isEditing ? "Edit Contact" : "Add Contact")
            .navigationBarTitleDisplayMode(isEditing ? .automatic : .inline)
            .sheet(isPresented: $showContactPicker) {
                ContactPicker(name: $name, number: $number)
            }
        }
    }

    private func saveContact() {
        HapticViewModel.shared.playSuccess()
        let newContact = Contact(
            name: name,
            number: number
        )
        detailsVM.saveContact(newContact, id: contact?.id, isEditing: isEditing)
        dismiss()
    }
}

struct ContactPicker: UIViewControllerRepresentable {
    @Binding var name: String
    @Binding var number: String
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPicker
        
        init(_ parent: ContactPicker) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                parent.name = contact.givenName + " " + contact.familyName
                parent.number = phoneNumber
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
}
