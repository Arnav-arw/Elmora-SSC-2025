//
//  ChatView.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import SwiftUI

struct ChatView: View {
    
    @State var currentInput: String = ""
    
    @State var chatVM = ChatViewModel()
    @State var detailsVM = DetailsViewModel.shared
    
    @State var shake: Bool = false
    @State var showChat: Bool = true
    @State var recommendation: String = Helper().getChatRecommendation()
    
    @FocusState var isFocused: Bool
    @Binding var showInstructions: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                chatView
                textfieldView
            }
        }
    }
    
    @ViewBuilder
    private var chatView: some View {
        GeometryReader { proxy in
            ScrollViewReader { value in
                if showChat {
                    if !chatVM.messages.isEmpty {
                        ScrollView(showsIndicators: false) {
                            LazyVStack {
                                ForEach(chatVM.messages, id: \.id) { message in
                                    messageView(message: message, screenProxy: proxy, scrollViewProxy: value)
                                }
                            }
                            .padding(.bottom, 150)
                            .padding(.top, 15)
                        }
                        .onChange(of: chatVM.messages.last?.content) {
                            scrollToBottom(proxy: value)
                        }
                        .safeAreaPadding(.bottom, 100)
                        .transition(.movingParts.vanish(.blue.opacity(0.4)))
                    } else {
                        ContentUnavailableView {
                            Image(systemName: "message")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                                .opacity(0.5)
                            Text("No conversation yet")
                                .fontWeight(.bold)
                        } description: {
                            Text("Try asking something like \n \(recommendation), \nI am here to assist.")
                                .padding(.top, 5)
                                .padding(.bottom)
                            if detailsVM.isDummyDataNeeded() {
                                VStack {
                                    Text("Looks like you are new here 👀")
                                        .fontWeight(.medium)
                                    Button {
                                        detailsVM.saveDummyData()
                                    } label: {
                                        Text("Tap here to fill dummy data")
                                            .multilineTextAlignment(.center)
                                            .font(.caption)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.roundedRectangle)
                                }
                                .padding(.vertical)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var textfieldView: some View {
        VStack {
            Spacer()
            VStack {
                if chatVM.messages.isEmpty {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(detailsVM.testPrompts, id: \.self) { prompt in
                                    Button {
                                        HapticViewModel.shared.selectionChanged()
                                        currentInput = prompt
                                    } label: {
                                        Text(prompt)
                                            .foregroundStyle(colorScheme == .light ? .black : .white)
                                            .lineLimit(2)
                                            .padding(.all, 15)
                                            .frame(height: 50)
                                            .background(.gray.opacity(0.2))
                                            .clipShape(.rect(cornerRadius: 12))
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                    }
                }
                ZStack {
                    HStack {
                        TextField("Type a message...", text: $currentInput, axis: .vertical)
                            .foregroundColor(.primary)
                            .padding(.all, 10)
                            .onChange(of: currentInput) {
                                if currentInput.last?.isNewline == .some(true) {
                                    currentInput.removeLast()
                                    isFocused = false
                                }
                            }
                            .focused($isFocused)
                        Spacer()
                        if !chatVM.messages.isEmpty {
                            Button {
                                recommendation = Helper().getChatRecommendation()
                                HapticViewModel.shared.playHaptic(of: .medium)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    chatVM.messages.removeAll()
                                    showChat.toggle()
                                }
                                withAnimation() {
                                    showChat.toggle()
                                }
                            } label: {
                                Circle()
                                    .foregroundStyle(.red.opacity(0.6))
                                    .frame(width: 35)
                                    .overlay {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                        Button {
                            guard !currentInput.isEmpty else {
                                HapticViewModel.shared.playError()
                                shake.toggle()
                                return
                            }
                            HapticViewModel.shared.playHaptic(of: .medium)
                            chatVM.processResponse(with: currentInput)
                            currentInput = ""
                            isFocused = false
                        } label: {
                            Circle()
                                .foregroundStyle(.blue)
                                .frame(width: 35)
                                .overlay {
                                    Image(systemName: "paperplane")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.thinMaterial)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
            }
        }
        .padding(.bottom, isFocused ? .zero : 70)
        .changeEffect(.shake, value: shake)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = chatVM.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .top)
    }
    
}

// MARK: CONTEXT MENU
extension ChatView {
    private func extraContextMenu(_ type: MessageType) -> some View {
        Group {
            switch type {
                    
                case .showInstructions:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You can check out what I can do here")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        Button {
                            showInstructions.toggle()
                        } label: {
                            HStack {
                                Text("See instructions")
                                Spacer()
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue.opacity(0.3))
                    }
                    
                case .goingToBed:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Set an alarm?")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        Button {
                            chatVM.handleSleep(with: true, isUsualTime: false)
                        } label: {
                            HStack {
                                Text("Yes sure")
                                Spacer()
                                Image(systemName: "alarm.waves.left.and.right.fill")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue.opacity(0.3))
                        
                        Button {
                            chatVM.handleSleep(with: true, isUsualTime: true)
                        } label: {
                            HStack {
                                Text("No, wake me up at my usual time")
                                Spacer()
                                Image(systemName: "alarm.waves.left.and.right")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            chatVM.handleSleep(with: false, isUsualTime: false)
                        } label: {
                            HStack {
                                Text("No, thanks")
                                Spacer()
                                Image(systemName: "poweroff")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                case .goingToShop:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nearby Stores")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        ForEach(detailsVM.stores) { store in
                            Button {
                                chatVM.handleGoingToShopResponse(with: store)
                            } label: {
                                HStack {
                                    Text("\(detailsVM.stores.firstIndex(where: { $0.id == store.id })! + 1). \(store.name)")
                                    Spacer()
                                    Image(systemName: "cart")
                                }
                                .foregroundStyle(.primary)
                                .font(.headline)
                                .padding(.vertical, 8)
                                .frame(maxWidth: 330, alignment: .leading)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    
                case .notificationOptions:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Set a Reminder?")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        Button {
                            chatVM.handleNotificationOption(true)
                        } label: {
                            HStack {
                                Text("✅ Yes, remind me")
                                Spacer()
                                Image(systemName: "bell.fill")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue.opacity(0.3))
                        
                        Button {
                            chatVM.handleNotificationOption(false)
                        } label: {
                            HStack {
                                Text("❌ No, thanks")
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                case .homeCheck:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Did you find it?")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        Button {
                            chatVM.handlePantryCheck(with: true)
                        } label: {
                            HStack {
                                Text("✅ Yes, I did.")
                                Spacer()
                                Image(systemName: "checkmark.seal.fill")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue.opacity(0.3))
                        
                        Button {
                            chatVM.handlePantryCheck(with: false)
                        } label: {
                            HStack {
                                Text("❌ No, I did not.")
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                case .showOutingPlanOptions:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Plan Recommendations")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        ForEach(detailsVM.plans) { plan in
                            HStack {
                                Text("\(detailsVM.plans.firstIndex(where: { $0.id == plan.id })! + 1). \(plan.plan)")
                                Spacer()
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 4)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                    }
                    
                case .goingOut:
                    VStack(alignment: .leading, spacing: 12) {
                        Button {
                            chatVM.handleOutingPlanSuggestionCheck(with: true)
                        } label: {
                            HStack {
                                Text("✅ Yeah! Sure go ahead.")
                                Spacer()
                                Image(systemName: "checkmark.seal.fill")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue.opacity(0.3))
                        
                        Button {
                            chatVM.handleOutingPlanSuggestionCheck(with: false)
                        } label: {
                            HStack {
                                Text("❌ No, it's fine")
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                            }
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .padding(.vertical, 8)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                case .dialNumber:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Favourite contacts")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        ForEach(detailsVM.favouriteContacts) { contact in
                            Button {
                                chatVM.handleCalling(contact.number)
                            } label: {
                                HStack {
                                    Text("\(detailsVM.favouriteContacts.firstIndex(where: { $0.id == contact.id })! + 1). \(contact.name)")
                                    Spacer()
                                }
                                .foregroundStyle(.primary)
                                .font(.headline)
                                .padding(.vertical, 8)
                                .frame(maxWidth: 330, alignment: .leading)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    
                case .medicine:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's medicines")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        ForEach(detailsVM.medicines) { medicine in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(detailsVM.medicines.firstIndex(where: { $0.id == medicine.id })! + 1). \(medicine.name) - \(medicine.dosage)")
                                    Text("\(medicine.frequency) \(medicine.notes != nil ? "|" : "") \(medicine.notes ?? "")")
                                        .font(.caption)
                                        .opacity(0.7)
                                }
                                Spacer()
                            }
                            .foregroundStyle(.blue)
                            .font(.headline)
                            .padding(.vertical, 4)
                            .frame(maxWidth: 330, alignment: .leading)
                        }
                    }
                    
            }
        }
        .padding(.all, 12)
        .background(Color(.systemGray6).opacity(0.8))
        .cornerRadius(12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: MESSAGE
extension ChatView {
    private func messageView(message: ChatMessage, screenProxy: GeometryProxy, scrollViewProxy: ScrollViewProxy) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(message.content)
                    .foregroundStyle(message.role == .user ? Color.primary : Color.white)
                    .padding(.all, 10)
                    .background {
                        if message.role == .user {
                            Rectangle()
                                .fill(.gray.opacity(0.2))
                                .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
                        } else {
                            GeometryReader {
                                let actualSize = $0.size
                                let rect = $0.frame(in: .global)
                                let screenSize = screenProxy.size
                                let safeArea = screenProxy.safeAreaInsets
                                Rectangle()
                                    .fill(.linearGradient(colors: [
                                        Color("c4"),
                                        Color("c3"),
                                        Color("c3"),
                                        Color("c2"),
                                        Color("c1"),
                                        Color("c1")
                                    ], startPoint: .top, endPoint: .bottom))
                                    .mask(alignment: .topLeading, {
                                        Rectangle()
                                            .cornerRadius(16, corners: [.topLeft, .topRight, .bottomRight])
                                            .frame(width: actualSize.width, height: actualSize.height)
                                            .offset(x: rect.minX, y: rect.minY)
                                    })
                                    .offset(x: -rect.minX, y: -rect.minY)
                                    .frame(width: screenSize.width - 100, height: screenSize.height + safeArea.top + safeArea.bottom)
                            }
                        }
                    }
                    .frame(maxWidth: 400, alignment: message.role == .user ? .trailing : .leading)
                    .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
            }
            if message.messageCompleted, let messageType = message.type {
                extraContextMenu(messageType)
                    .onFirstAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            scrollToBottom(proxy: scrollViewProxy)
                        }
                    }
            }
        }
    }
}
