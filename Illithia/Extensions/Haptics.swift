//
//  Haptics.swift
//  Illithia
//
//  Created by Angelo Carasig on 1/9/2024.
//

import Foundation
import UIKit

class Haptics {
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    static func success() {
        notification(type: .success)
    }
    
    static func warning() {
        notification(type: .warning)
    }
    
    static func error() {
        notification(type: .error)
    }
}
