//
//  String++.swift
//  WWDC2025
//
//  Created by Arnav Singhal on 23/02/25.
//

import SwiftUI

extension String {
    func containsWord(_ word: String) -> Bool {
        // Use a regular expression to find whole word matches
        let pattern = "\\b\(NSRegularExpression.escapedPattern(for: word))\\b"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.utf16.count)
        
        if let matches = regex?.matches(in: self, options: [], range: range), matches.count > 0 {
            return true
        }
        
        return false
    }
}
