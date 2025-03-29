//
//  TabContainerView.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import SwiftUI

struct TabContainerView: View {
    
    @State private var activeTab: Tabs = .chat
    @State private var tabShapePosition: CGPoint = .init(x: 105, y: 0)
    @State private var showInstructions: Bool = false
    
    @Namespace private var animation
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopBarView
                ZStack {
                    TabView(selection: $activeTab) {
                        ChatView(isFocused: _isFocused, showInstructions: $showInstructions)
                            .tag(Tabs.chat)
                        DetailsView()
                            .tag(Tabs.details)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    CustomTabBar
                        .padding(.bottom, -12)
                        .offset(y: isFocused ? 100 : .zero)
                }
            }
            .fullScreenCover(isPresented: $showInstructions) {
                InstructionsView()
            }
        }
    }
    
    @ViewBuilder
    var TopBarView: some View {
        VStack {
            HStack {
                HStack {
                    if activeTab == .chat {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Assistant")
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                                .font(.title3)
                            Text("Hi there 👋")
                                .fontDesign(.rounded)
                                .fontWeight(.medium)
                                .font(.subheadline)
                                .opacity(0.6)
                        }
                        .opacity(activeTab == .chat ? 1 : 0)
                    }
                   
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Details")
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .font(.title3)
                        Text("All your details in one place")
                            .fontDesign(.rounded)
                            .fontWeight(.medium)
                            .font(.subheadline)
                            .opacity(0.6)
                    }
                    .opacity(activeTab == .details ? 1 : 0)
                    
                }
                .animation(.bouncy, value: activeTab)
                Spacer()
                Button {
                    showInstructions.toggle()
                } label: {
                    Image(systemName: "questionmark.circle.dashed")
                        .resizable()
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .scaledToFit()
                        .frame(height: 24)
                }
            }
        }
        .animation(.smooth, value: activeTab)
        .padding(.all)
        .background {
            Color.gray.opacity(0.1)
                .ignoresSafeArea(.all)
        }
    }
    
    @ViewBuilder
    var CustomTabBar: some View {
        VStack {
            Spacer()
            HStack(alignment:.bottom, spacing: 0) {
                ForEach(Tabs.allCases, id: \.rawValue) {
                    TabItem(tab: $0, animation: animation, activeTab: $activeTab, tabPosition: $tabShapePosition)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(content: {
                CustomTabBarShape(midpoint: tabShapePosition.x)
                    .fill(.thinMaterial)
                    .ignoresSafeArea()
                    .padding(.top, 25)
            })
            .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
        }
    }
    
}
