//
//  PushDownButton.swift
//  WWDC2025
//
//  Created by Arnav Personal on 23/02/25.
//

import SwiftUI

struct PushDownButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed ? 0.75 : 1)
//      .conditionalEffect(
//        .pushDown,
//        condition: configuration.isPressed
//      )
  }
}
