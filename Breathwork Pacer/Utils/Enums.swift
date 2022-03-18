//
//  Enums.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import Foundation

enum SoundControlType:String, CaseIterable {
    case none, yoga, tone
    
    func getInhaleFilename() -> String? {
        switch self {
        case .none:
            return nil
        case .yoga:
            return "yoga-inhale"
        case .tone:
            return "high-piano-note"
        }
    }
    
    func getExhaleFilename() -> String? {
        switch self {
        case .none:
            return nil
        case .yoga:
            return "yoga-exhale"
        case .tone:
            return "low-piano-note"
        }
    }
}


enum BreathAnimationType:String {
    case circleAnimation, boxAnimation, countAnimation
}
