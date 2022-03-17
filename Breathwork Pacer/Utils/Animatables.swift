//
//  Animatables.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import Foundation

class Animatables {
    
    static private var scaleValue:Double = 0.0
    
    
    static func getScaleValueForBreathStepWorkout(_ workout:Workout) -> Double {
        
        let totalElapsedTime = workout.totalElapsedTime
        
        guard totalElapsedTime > 0.0 else {
            scaleValue = 0.0
            return scaleValue
        }
        
        let stepElapsedTime = workout.stepElapsedTime
        let breathStep = workout.currentStep
        let stepType = BreathStepType.stepTypeForString(breathStep.type)
        let stepDuration = breathStep.duration
        let percentageComplete = (stepElapsedTime / stepDuration * 100.0).rounded(.toNearestOrAwayFromZero)
        
        switch stepType {
        case .inhale:
            scaleValue = percentageComplete / 100
            if scaleValue > 0.98 { scaleValue = 1.0 }
        case .exhale:
            scaleValue = (1 - percentageComplete / 100)
            if scaleValue < 0.03 { scaleValue = 0.0 }
        default:
            break
        }
        
        return easeInOutSineFromPercentage(scaleValue)
    }
    
    private static func easeInOutSineFromPercentage(_ percentage:Double) -> Double {
        return -(cos(Double.pi * percentage) - 1.0) / 2.0
    }
    
    private static func easeInOutCubicFromPercentage(_ p:Double) -> Double {
        return p < 0.5 ? 4 * p * p * p : 1 - pow(-2.0 * p + 2.0, 3) / 2
    }
    
}
