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
    
    private var colours = Settings.colours
    
    private var timer = Timer()
    private var soundProvider = SoundProvider.shared
    private var settings = Settings.shared
    
    // store a reference to the audio control as it can't be destroyed
    
    init(breathSet:BreathSet) {
        
        let isFirstRun = UserDefaults.standard.bool(forKey: GlobalConstants.dataIsPreloadedKey)
        
        // create workout based on UserDefaults
        if isFirstRun {
            
        }
        
        self.workout = Workout(breathSet: breathSet,
                               totalSecondsDuration: settings.defaultTimer,
                               animationColor: settings.defaultColor,
                               soundControlType: settings.defaultSoundType,
                               animationType: settings.defaultAnimationType)
    }
    
    // MARK: - Background Mode
    func setNewScenePhase(_ newPhase:ScenePhase) {
        
        switch newPhase {
        case .background:
            fallthrough
        case .inactive:
            pauseSession()
        default:
            return
        }
        
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
    func colorFromDescription(_ description:String) -> Color { settings.colorFromDescription(description) }
    
    func changeToNextColour() {
        
        let selectedColour = colorFromDescription(self.workout.animationColor)
        
        let currentIndex = self.colours.firstIndex(of: selectedColour) ?? 0
        
        guard currentIndex+1 < self.colours.count-1 else {
            //
            self.workout.changeAnimationColorTo(self.colours.first!.description)
            return
        }
        
        self.workout.changeAnimationColorTo(colours[currentIndex+1].description)
        
        settings.saveDefaultColorTo(self.workout.animationColor.description)
    }
    
    // MARK: - Animation
    func changeAnimationTypeTo(_ selectedAnimation:BreathAnimationType) {
        self.workout.changeAnimationTypeTo(selectedAnimation)
        settings.saveDefaultAnimationTo(selectedAnimation.rawValue)
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
        
        return max(((totalSeconds - totalElapsedSeconds) % numSecondsInAMinute), 0)
    }
    
    func setNewTotalDurationFromMinutes(_ minutes:Int, seconds:Int) {
        
        let totalSeconds = minutes * 60 + seconds
        settings.saveDefaultTimerTo(totalSeconds)
        self.workout.resetWorkout()
    }
    
    func saveDefaultTimerDuration(_ minutes:Int, _ seconds:Int) {
        let totalSeconds = minutes * 60 + seconds
        settings.saveDefaultTimerTo(totalSeconds)
    }
    
    func getDefaultMinutes() -> Int {
        // TODO: Probably need to update this to user defaults, but we'll use workout for now
        return Int(settings.defaultTimer / 60)
    }
    
    func getDefaultSeconds() -> Int {
        // TODO: Probably need to update this to user defaults, but we'll use workout for now
        return settings.defaultTimer % 60
    }
    
    // MARK: - Timer Session Controls
    func pauseSession() {
        self.timer.invalidate()
        self.workout.setIsPlaying(false)
        pauseSound()
    }
    
    func playSession() {
        
        if self.workout.totalElapsedTime == 0.0 { playNewSound() } else { resumeSound() }
        
        
        self.timer = Timer(timeInterval: GlobalConstants.timerDelay, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        self.workout.setIsPlaying(true)
    }
    
    @objc func fireTimer() {
        // if elapsed time == total time, stop time and finish session
        // this is handled inside the workout model.
        let lastStep = self.workout.currentStep
        self.workout.incrementElapsedTime(amount: GlobalConstants.timerDelay)
        
        // If the last step is different to the current step
        // start new sound.
        if lastStep != self.workout.currentStep {
            playNewSound()
        }
        
        // If we're at the end of the session, stop the timer.
        if Int(self.workout.totalElapsedTime) >= self.workout.totalSecondsDuration {
            self.pauseSession()
            workout.resetWorkout()
            soundProvider.playSessionEndSound()
        }
    }
    
    // MARK: - BreathStep
    func getStepActionText() -> String {
        self.workout.currentStep.type.capitalized
    }
    
    // MARK: - Sounds Controls
    func changeSoundTypeTo(_ selectedSoundType:SoundControlType) {
        self.workout.changeSoundTypeTo(selectedSoundType)
        settings.saveDefaultSoundTo(selectedSoundType.rawValue)
    }
}
