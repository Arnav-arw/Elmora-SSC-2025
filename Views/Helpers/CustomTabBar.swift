//
//  CustomTabBar.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import Foundation
import SwiftUI

struct TabItem: View {
    
    var tab: Tabs
    var animation: Namespace.ID
    @Binding var activeTab: Tabs
    @Binding var tabPosition: CGPoint
    
    init(tab: Tabs, animation: Namespace.ID, activeTab: Binding<Tabs>, tabPosition: Binding<CGPoint>) {
        self.tab = tab
        self.animation = animation
        self._activeTab = activeTab
        self._tabPosition = tabPosition
    }
    
    var tint: Color = .gray
    var inactiveTint: Color = .blue
    
    var hapticVM = HapticViewModel.shared
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : tint)
                .frame(width: activeTab == tab ? 50 : 35, height: activeTab == tab ? 50 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(inactiveTint.gradient)
                            .matchedGeometryEffect(id: "ACTIVE_TAB", in: animation)
                    }
                }
            
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundColor(activeTab == tab ? inactiveTint : tint)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 5)
        .contentShape(Rectangle())
        .getGlobalRect(true, completion: { rect in
            if activeTab == tab {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    tabPosition.x = rect.midX
                }
            }
        })
        .onTapGesture {
            hapticVM.selectionChanged()
            withAnimation(.easeInOut(duration: 0.3)) {
                activeTab = tab
            }
        }
    }
}


struct CustomTabBarShape: Shape {
    
    var midpoint: CGFloat
    var animatableData: CGFloat {
        get { midpoint }
        set { midpoint = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addPath(Rectangle().path(in: rect))
            
            path.move(to: CGPoint(x: midpoint - 60, y: 0))
            
            let to1 = CGPoint(x: midpoint, y: -25)
            let control1 = CGPoint(x: midpoint - 25, y: 0)
            let control2 = CGPoint(x: midpoint - 25, y: -25)
            path.addCurve(to: to1, control1: control1, control2: control2)
            
            let to2 = CGPoint(x: midpoint + 60, y: 0)
            let control3 = CGPoint(x: midpoint + 25, y: -25)
            let control4 = CGPoint(x: midpoint + 25, y: 0)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
