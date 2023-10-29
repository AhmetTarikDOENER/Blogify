//
//  BfyHapticsManager.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 30.10.2023.
//

import Foundation
import UIKit

class BfyHapticsManager {
    
    static let shared = BfyHapticsManager()
    
    private init() {}
    
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
}
