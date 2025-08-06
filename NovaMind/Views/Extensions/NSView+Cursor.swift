import AppKit
import SwiftUI

//
//  NSView+Cursor.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-31.
//


extension View {
    func cursor(_ cursor: NSCursor) -> some View {
        self.onHover { inside in
            if inside {
                cursor.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}

// Custom cursor extension for resize operations
extension NSCursor {
    static let resizeLeftRight = NSCursor.resizeLeftRight
    static let resizeUpDown = NSCursor.resizeUpDown
}
