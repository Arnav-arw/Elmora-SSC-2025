//
//  InstructionsView.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI
import AVKit

struct InstructionsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var currentPage = 0
    @State var numberOfPages = 5
    
    var isFromOnboarding: Bool = false
    
    @AppStorage("isFirstTimeLaunch") var isFirstTimeLaunch: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Discover what and how Elmora can assist you with swipe to explore! 👀")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 25)
                    .opacity(0.8)
                TabView(selection: $currentPage) {
                    InstructionsDetailView(
                        video: "medicine",
                        title: "Medicine Reminder 💊",
                        subtitle: "Ask AI for 'What medicine should I take today?', and it will respond accordingly. It will also remind the user when to take medicine.",
                        howItWorks: "The AI identifies keywords in the user’s input, such as ‘medicine’ and ‘today.’ It then checks the available medicine data, and fetches the most relevant information. Additionally, it ensures that notifications are set up for timely reminders, helping users stay on track with their medication.",
                        avPlayer: AVPlayer(url: Bundle.main.url(forResource: "medicine", withExtension: "mov")!)
                    )
                    .tag(0)
                    InstructionsDetailView(
                        video: "goingToShop",
                        title: "Going to Shop 🛍️",
                        subtitle: "Ask AI 'What should I buy today?' or 'Where's the nearest store?', and it will guide you accordingly.",
                        howItWorks: "The AI detects keywords like ‘shop’ and ‘buy’ in the user’s input. It then checks stored stores to suggest relevant items or locations, helping users plan their shopping efficiently. Additionally, it sets a reminder for the estimated return time, ensuring the user is back home safely. If the user doesn’t confirm their return, it can send a gentle follow-up reminder.",
                        avPlayer: AVPlayer(url: Bundle.main.url(forResource: "goingToShop", withExtension: "mov")!)
                    )
                    .tag(1)
                    InstructionsDetailView(
                        video: "goingToBed",
                        title: "Bedtime Routine 🌙",
                        subtitle: "Say 'Remind me to take my night medicine' or 'Set an alarm for 7 AM,' and it will assist you in winding down.",
                        howItWorks: "The AI recognizes phrases related to sleep, medicine, and alarms. It retrieves scheduled medications, bedtime reminders, and alarm preferences, ensuring users follow their nighttime routine smoothly.",
                        avPlayer: AVPlayer(url: Bundle.main.url(forResource: "goingToBed", withExtension: "mov")!)
                    )
                    .tag(2)
                    InstructionsDetailView(
                        video: "goingOut",
                        title: "Planning an Outing 🎉",
                        subtitle: "Ask 'What’s my plan for today?' or 'Where can I go with friends?', and AI will help you decide.",
                        howItWorks: "The AI analyzes user input for keywords like ‘going out’ or ‘plan.’ It then checks saved plans, upcoming events, and preferred locations to suggest the best options for an enjoyable outing.",
                        avPlayer: AVPlayer(url: Bundle.main.url(forResource: "goingOut", withExtension: "mov")!)
                    )
                    .tag(3)
                    InstructionsDetailView(
                        video: "dialNumber",
                        title: "Quick Dial 📞",
                        subtitle: "Say 'Call Mom' or when you need someone's help, and AI will handle the rest.",
                        howItWorks: "The AI detects names or numbers in the user’s request. It then searches the contact list to match the requested person and initiates a call instantly, making communication effortless.",
                        avPlayer: AVPlayer(url: Bundle.main.url(forResource: "dialNumber", withExtension: "mov")!)
                    )
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                Spacer()
                PageControlView(currentPage: $currentPage, numberOfPages: $numberOfPages)
            }
            .navigationTitle("What can I help you with?")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if isFromOnboarding {
                        Button {
                            withAnimation(.bouncy) {
                                isFirstTimeLaunch = false
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("Done")
                            }
                        }
                    } else {
                        Button {
                            dismiss()
                        } label: {
                            Label("Back", systemImage: "chevron.down")
                        }
                    }
                }
            }
        }
    }
}

struct InstructionsDetailView: View {
    
    var video: String
    var title: String
    var subtitle: String
    var howItWorks: String
    
    @State var avPlayer: AVPlayer?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .padding(.top, 30)
                    .fontWeight(.heavy)
                Text(subtitle)
                Text("How it works? 🤔")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 100)
                Text(howItWorks)
                    .opacity(0.7)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .padding([.top, .trailing])
            
            VideoPlayer(player: avPlayer)
                .aspectRatio(4/3, contentMode: .fit)
                .cornerRadius(12)
                .frame(width: UIScreen.main.bounds.width / 1.75)
                .padding(.horizontal)
                .background(.gray.opacity(0.1))
                .cornerRadius(12)
                .onAppear {
                    avPlayer?.play()
                }
                .onDisappear {
                    avPlayer?.pause()
                }
                .onTapGesture {
                    avPlayer?.play()
                }
        }
        .padding(.horizontal, 40)
    }
}

extension AVPlayerViewController {
    open override func viewDidLoad() {
        view.backgroundColor = .clear
    }
}
