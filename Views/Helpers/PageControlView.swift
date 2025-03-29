//
//  PageControlView.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI

struct PageControlView: UIViewRepresentable {
    
    @Binding var currentPage: Int
    @Binding var numberOfPages: Int

    func makeUIView(context: Context) -> UIPageControl {
        let uiView = UIPageControl()
        uiView.backgroundStyle = .prominent
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
        return uiView
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }
    
}
