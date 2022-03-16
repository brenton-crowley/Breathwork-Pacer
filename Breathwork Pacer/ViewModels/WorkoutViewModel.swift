//
//  WorkoutViewModel.swift
//  Breathwork Pacer
//
//  Created by Brent on 16/3/2022.
//

import Foundation
import SwiftUI

class WorkoutViewModel: ObservableObject {
    
    @Published private(set) var workout:Workout
    
    let colours:[Color] = [.blue, .yellow, .red, .gray, .brown, .cyan, .green, .indigo, .mint, .orange, .pink, .purple]
    
    init(breathSet:BreathSet) {
        
        let isFirstRun = UserDefaults.standard.bool(forKey: Constants.dataIsPreloadedKey)
        
//        let defaults = UserDefaults.standard
        
        // create workout based on UserDefaults
        if isFirstRun {
            
        }
        
        let firstStep:BreathStep = breathSet.steps?.allObjects.first as! BreathStep
        
        self.workout = Workout(breathSet: breathSet,
                               totalSecondsDuration: 60 * 20,
                               currentStep: firstStep,
                               animationColor: Color.blue.description,
                               soundControlType: SoundControl.SoundControlType.none,
                               animationType: BreathAnimationTabView.BreathAnimationType.circleAnimationTag)
    }
    
    func colorFromDescription(_ description:String) -> Color {
        
        let colorFromDescription = colours.filter { $0.description == description }
        var color:Color
        if let match = colorFromDescription.first {
            color = match
        } else {
            color = .blue
        }
            
        return color
        
    }
    
    func changeToNextColour() {
        
        let selectedColour = colorFromDescription(self.workout.animationColor)
        
        let currentIndex = self.colours.firstIndex(of: selectedColour) ?? 0
        
        guard currentIndex+1 < self.colours.count-1 else {
            //
            self.workout.changeAnimationColorTo(self.colours.first!.description)
            return
        }
        
        self.workout.changeAnimationColorTo(colours[currentIndex+1].description)
        
    }
    
    func changeAnimationTypeTo(_ selectedAnimation:BreathAnimationTabView.BreathAnimationType) {
        self.workout.changeAnimationTypeTo(selectedAnimation)
    }
    
    func getCountdownMinutes() -> Int {
        // floor start time - elapsed time / 60
        let startSeconds = self.workout.totalSecondsDuration
        let elapsedSeconds = self.workout.elapsedSecondsCount
        let numSecondsInAMinute = 60
        
        return Int((startSeconds - elapsedSeconds) / numSecondsInAMinute)
    }
    
    func getCountdownSeconds() -> Int {
        // floor start time - elapsed time % 60
        
        let startSeconds = self.workout.totalSecondsDuration
        let elapsedSeconds = self.workout.elapsedSecondsCount
        let numSecondsInAMinute = 60
        
        return (startSeconds - elapsedSeconds) % numSecondsInAMinute
    }
    
    func setNewTotalDurationFromMinutes(_ minutes:Int, seconds:Int) {
        
        let totalSeconds = minutes * 60 + seconds
        self.workout.updateTotalSecondsDurationTo(totalSeconds: totalSeconds)
        
        // TODO: Update User Defaults with this value
    }
    
}
