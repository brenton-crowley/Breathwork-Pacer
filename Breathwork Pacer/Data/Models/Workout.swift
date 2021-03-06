//
//  Workout.swift
//  Breathwork Pacer
//
//  Created by Brent on 16/3/2022.
//

import Foundation

struct Workout {
    
    private struct Constants {
        static let scaleFactor = 1000.0
    }
    
    private(set) var id = UUID()
    private(set) var stepElapsedTime:Double = 0
    // TODO: - Handle for decimal amounts and change to a Double
    private(set) var totalElapsedTime:Double = 0
    private(set) var breathSet:BreathSet
    private(set) var currentStepIndex:Int = 0
    private(set) var animationColor:String
    private(set) var soundControlType:SoundControlType
    private(set) var animationType:BreathAnimationType
    
    var totalSecondsDuration:Int { Settings.shared.defaultTimer }
    
    var currentStep:BreathStep {
        guard self.currentStepIndex < steps.count else { return steps.first! }
        
        return steps[currentStepIndex]
    }
    
    var steps:[BreathStep] {
        let breathSteps = self.breathSet.steps?.allObjects as! [BreathStep]
        if !breathSteps.isEmpty {
            return breathSteps.sorted { $0.sortOrder < $1.sortOrder }
        } else {
            return []
        }
    }
    
    var isPlaying:Bool = false
    
    init(breathSet:BreathSet,
         totalSecondsDuration:Int,
         animationColor:String,
         soundControlType:SoundControlType,
         animationType:BreathAnimationType) {
        
        self.breathSet = breathSet
        self.animationColor = animationColor
        self.soundControlType = soundControlType
        self.animationType = animationType
    }
    
    mutating func changeAnimationColorTo(_ color:String) {
        self.animationColor = color.description
    }
    
    mutating func changeAnimationTypeTo(_ selectedAnimation:BreathAnimationType) {
        self.animationType = selectedAnimation
    }
    
    mutating func toggleIsPlaying() {
        self.isPlaying.toggle()
    }
    
    mutating func setIsPlaying(_ isPlaying:Bool) {
        self.isPlaying = isPlaying
    }
    
    // TODO: - Handle for decimal amounts
    mutating func incrementElapsedTime(amount:Double) {
        self.totalElapsedTime = roundedDouble(self.totalElapsedTime + amount)
        self.stepElapsedTime = roundedDouble(self.stepElapsedTime + amount)
        
        if self.stepElapsedTime >= self.currentStep.duration {
            self.stepElapsedTime = 0.0
            gotoNextStep()
        }
    }
    
    mutating private func roundedDouble(_ value: Double) -> Double {
        (value * Constants.scaleFactor).rounded() / Constants.scaleFactor
    }
    
    mutating func gotoNextStep() {
        
        let matchedIndex = steps.firstIndex { $0.id == self.currentStep.id }
        
        // if the step isn't in our steps, exit.
        guard var index = matchedIndex else { return }
        
        // Reset to zero as we're at the end of the set.
        guard index + 1 < steps.count else {
            self.currentStepIndex = 0
            return
        }
        
        // Increment the index of the next step.
        index += 1
        self.currentStepIndex = index
        
    }
        
    mutating func resetWorkout() {
        self.totalElapsedTime = 0
        self.stepElapsedTime = 0
        self.currentStepIndex = 0
        print("reset workout")
    }
    
    mutating func changeSoundTypeTo(_ selectedSoundType:SoundControlType) {
        self.soundControlType = selectedSoundType
    }
}
