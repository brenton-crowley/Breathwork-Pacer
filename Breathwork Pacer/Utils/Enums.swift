//
//  Enums.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import Foundation

enum BreathStepType: String, CaseIterable {
    
    case rest = "rest"
    case inhale = "inhale"
    case exhale = "exhale"
    
    static func stepTypeForString(_ text:String) -> BreathStepType {
        
        switch text.lowercased() {
            
        case BreathStepType.inhale.rawValue:
            return .inhale
        case BreathStepType.exhale.rawValue:
            return .exhale
        case BreathStepType.rest.rawValue:
            return .rest
        default:
            return .inhale
            
        }
        
    }
    
}


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
    
    static func soundTypeForString(_ text:String) -> SoundControlType {
        
        switch text.lowercased() {
            
        case SoundControlType.none.rawValue:
            return .none
        case SoundControlType.yoga.rawValue:
            return .yoga
        case SoundControlType.tone.rawValue:
            return .tone
        default:
            return .none
        }
    }
}


enum BreathAnimationType:String {
    case circleAnimation, boxAnimation, countAnimation
    
    static func animationTypeForString(_ text:String) -> BreathAnimationType {
        
        switch text {
        case BreathAnimationType.circleAnimation.rawValue:
            return .circleAnimation
        case BreathAnimationType.boxAnimation.rawValue:
            return .boxAnimation
        case BreathAnimationType.countAnimation.rawValue:
            return .countAnimation
        default:
            return .circleAnimation
        }
        
    }
}
