//
//  Enumerations.swift
//  Breathwork Pacer
//
//  Created by Brent on 8/3/2022.
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
