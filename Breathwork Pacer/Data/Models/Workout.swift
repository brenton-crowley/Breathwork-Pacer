//
//  Workout.swift
//  Breathwork Pacer
//
//  Created by Brent on 16/3/2022.
//

import Foundation

struct Workout {
    
    private(set) var id = UUID()
    private(set) var currentStepCount:Int = 0
    private(set) var elapsedSecondsCount:Int = 0
    private(set) var breathSet:BreathSet
    private(set) var totalSecondsDuration:Int
    private(set) var currentStep:BreathStep
    private(set) var animationColor:String
    private(set) var soundControlType:SoundControl.SoundControlType
    private(set) var animationType:BreathAnimationTabView.BreathAnimationType
    
    var isPlaying:Bool = false
    
    mutating func changeAnimationColorTo(_ color:String) {
        self.animationColor = color.description
    }
    
    mutating func changeAnimationTypeTo(_ selectedAnimation:BreathAnimationTabView.BreathAnimationType) {
        self.animationType = selectedAnimation
    }
    
    mutating func updateTotalSecondsDurationTo(totalSeconds:Int) {
        self.totalSecondsDuration = totalSeconds
    }
}
