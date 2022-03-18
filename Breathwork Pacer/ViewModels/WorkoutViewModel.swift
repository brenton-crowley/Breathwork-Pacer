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
    
    private var timer = Timer()
    private var soundProvider = SoundProvider.shared
    
    // store a reference to the audio control as it can't be destroyed
    
    init(breathSet:BreathSet) {
        
        let isFirstRun = UserDefaults.standard.bool(forKey: Constants.dataIsPreloadedKey)
        
//        let defaults = UserDefaults.standard
        
        // create workout based on UserDefaults
        if isFirstRun {
            
        }
        
        self.workout = Workout(breathSet: breathSet,
                               totalSecondsDuration: 60 * 20,
                               animationColor: Color.blue.description,
                               soundControlType: SoundControlType.none,
                               animationType: BreathAnimationType.circleAnimation)
    }
    
    // MARK: - Sounds
    
    // start new sound
    func playNewSound() {
        soundProvider.playStepSound(self.workout.currentStep, forSoundType: self.workout.soundControlType)
        
    }
    
    func pauseSound() {
        soundProvider.pauseSound()
    }
    
    func resumeSound() {
        soundProvider.resumeSound()
    }
    
    // toggle playing
    func toggleSoundPlaying() {
        soundProvider.togglePlaying()
    }
    
    // stop sound
    func stopPlaying() {
        soundProvider.stopSound()
    }
    
    // MARK: - Colours
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
    
    // MARK: - Animation
    func changeAnimationTypeTo(_ selectedAnimation:BreathAnimationType) {
        self.workout.changeAnimationTypeTo(selectedAnimation)
    }
    
    
    // MARK: - Time Calculations
    func getCountdownMinutes() -> Int {
        // floor start time - elapsed time / 60
        let startSeconds = Double(self.workout.totalSecondsDuration)
        let totalElapsedTime = self.workout.totalElapsedTime
        let numSecondsInAMinute = 60.0
        
        return Int((startSeconds - totalElapsedTime) / numSecondsInAMinute)
    }
    
    func getCountdownSeconds() -> Int {
        // floor start time - elapsed time % 60
        
        let totalSeconds = self.workout.totalSecondsDuration
        let totalElapsedSeconds = Int(self.workout.totalElapsedTime.rounded(.up))
        let numSecondsInAMinute = 60
        
        return (totalSeconds - totalElapsedSeconds) % numSecondsInAMinute
    }
    
    func setNewTotalDurationFromMinutes(_ minutes:Int, seconds:Int) {
        
        let totalSeconds = minutes * 60 + seconds
        self.workout.updateTotalSecondsDurationTo(totalSeconds: totalSeconds)
        self.workout.resetElapsedTime()
        // TODO: Update User Defaults with this value
    }
    
    func getDefaultMinutes() -> Int {
        // TODO: Probably need to update this to user defaults, but we'll use workout for now
        return Int(self.workout.totalSecondsDuration / 60)
    }
    
    func getDefaultSeconds() -> Int {
        // TODO: Probably need to update this to user defaults, but we'll use workout for now
        return self.workout.totalSecondsDuration % 60
    }
    
    // MARK: - Timer Session Controls
    func pauseSession() {
        self.timer.invalidate()
        self.workout.setIsPlaying(false)
        pauseSound()
    }
    
    func playSession() {
        
        if self.workout.totalElapsedTime == 0.0 { playNewSound() } else { resumeSound() }
        
        
        self.timer = Timer(timeInterval: Constants.timerDelay, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        self.workout.setIsPlaying(true)
    }
    
    @objc func fireTimer() {
        // if elapsed time == total time, stop time and finish session
        // this is handled inside the workout model.
        let lastStep = self.workout.currentStep
        self.workout.incrementElapsedTime(amount: Constants.timerDelay)
        
        // If the last step is different to the current step
        // start new sound.
        if lastStep != self.workout.currentStep {
            playNewSound()
        }
        
        // If we're at the end of the session, stop the timer.
        if Int(self.workout.totalElapsedTime) >= self.workout.totalSecondsDuration {
            self.timer.invalidate()
        }
    }
    
    // MARK: - BreathStep
    func getStepActionText() -> String {
        self.workout.currentStep.type.capitalized
    }
    
    // MARK: - Sounds Controls
    func changeSoundTypeTo(_ selectedSoundType:SoundControlType) {
        self.workout.changeSoundTypeTo(selectedSoundType)
    }
}
