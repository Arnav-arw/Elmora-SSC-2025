//
//  OnboardingView.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var currentPage: Int = 0
    @State var showInstructions: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if showInstructions {
                    InstructionsView(isFromOnboarding: true)
                } else {
                    TabView(selection: $currentPage) {
                        IntroView(currentPage: $currentPage)
                            .tag(0)
                        AppInfoView(showInstructions: $showInstructions)
                            .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .onChange(of: currentPage) {
                HapticViewModel.shared.selectionChanged()
            }
        }
    }
    
}

struct AppInfoView: View {
    
    @Binding var showInstructions: Bool
    
    @State var showSubtitle: Bool = false
    @State var showDetails: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("Why I Built Elmora")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("I created Elmora after realizing how many elderly individuals rely heavily on others for everyday tasks. This dependence not only limits their freedom but also affects their overall well-being. I wanted to build a solution that empowers them to be more independent, allowing them to spend quality time with their loved ones rather than getting caught up in mundane tasks.")
                        .font(.title2)
                        .opacity(showSubtitle ? 0.8 : 0)
                        .padding(.bottom, 20)
                    
                    Text("Elmora is my attempt at showcasing an offline AI assistant that ensures data privacy while still being highly intelligent and helpful. Unlike cloud-based AI, Elmora processes everything locally on the device, keeping personal information secure. It learns about the user through manual input and automatic sources like calendar sync, providing tailored assistance without compromising privacy.")
                        .font(.title2)
                        .opacity(showDetails ? 1 : 0)
                        .padding(.bottom, 20)
                    
                    Text("The AI works by analyzing the user’s input, recognizing keywords, and taking appropriate actions. For instance, if the user says ‘I’m going shopping,’ Elmora can check relevant details, suggest a store, and even set a reminder to ensure they return home safely. This simple yet effective system makes daily tasks easier and more intuitive for elderly users.")
                        .font(.title2)
                        .fontWeight(.medium)
                        .opacity(showDetails ? 1 : 0)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 50)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        showInstructions = true
                    } label: {
                        HStack {
                            Text("Try it out!")
                            Image(systemName: "chevron.right")
                        }
                        .bold()
                        .font(.title3)
                        .foregroundStyle(.white)
                    }
                    .padding(.all)
                    .background(.blue)
                    .clipShape(.capsule)
                    .padding(.all, 50)
                }
            }
        }
        .onFirstAppear {
            withAnimation(.easeIn(duration: 1)) {
                showSubtitle = true
            }
            withAnimation(.easeIn(duration: 2.5)) {
                showDetails = true
            }
        }
    }
}


struct IntroView: View {
    
    @Binding var currentPage: Int
    
    @State var showSubtitle: Bool = false
    @State var showAppInfo: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                HStack(alignment: .center) {
                    Image(.arnav)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .background(.gray.opacity(0.3))
                        .clipShape(.circle)
                    VStack(alignment: .leading) {
                        Text("Hey there 👋")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("I am Arnav Singhal")
                            .font(.title)
                            .fontWeight(.medium)
                            .opacity(0.8)
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    Spacer()
                }
                .padding(.all, 50)
                VStack(alignment: .leading) {
                    Text("I’m beyond excited to showcase my 2025 WWDC Swift Student Challenge submission! This project has been a labor of hard work and love, and I can’t wait for you all to experience it.")
                        .font(.title2)
                        .opacity(showSubtitle ? 0.8 : 0)
                    Text("Introducing Elmora – a smart, interactive chatbot designed to support older adults in their daily lives. Whether it’s going out for shopping, staying organized, or getting helpful medicine reminders, or making plans with friends and family, Elmora ensures they can maintain their independence while receiving the assistance they need.")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top)
                        .opacity(showAppInfo ? 1 : 0)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 50)
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        currentPage += 1
                    } label: {
                        HStack {
                            Text("Continue")
                            Image(systemName: "chevron.right")
                        }
                        .bold()
                        .font(.title3)
                        .foregroundStyle(.white)
                    }
                    .padding(.all)
                    .background(.blue)
                    .clipShape(.capsule)
                    .padding(.all, 50)
                }
            }
        }
        .onFirstAppear {
            withAnimation(.easeIn(duration: 1)) {
                showSubtitle = true
            }
            withAnimation(.easeIn(duration: 2.5)) {
                showAppInfo = true
            }
        }
    }
}
