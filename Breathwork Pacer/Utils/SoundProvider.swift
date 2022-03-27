//
//  SoundProvider.swift
//  Breathwork Pacer
//
//  Created by Brent on 18/3/2022.
//

import AVFoundation

class SoundProvider {
    
    static let shared = SoundProvider()
    
    private var currentSound:AVAudioPlayer?
    private var audioSession:AVAudioSession
    
    private init() {
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print(error)
        }
        
    }
    
    // when the step changes, we need to know if we should play a sound
    // this logic is outside of the sound provider
    // the soundprovider must offer an interface to play a sound based on the type.
    
    func playStepSound(_ step:BreathStep, forSoundType soundType:SoundControlType) {
        
        let breathType = BreathStepType.stepTypeForString(step.type)
        var newSound:AVAudioPlayer?
        
        switch breathType {
        case .rest:
            return
        case .inhale:
            newSound = loadSoundFromFileName(soundType.getInhaleFilename())
        case .exhale:
            newSound = loadSoundFromFileName(soundType.getExhaleFilename())
        }
        
        if let newSound = newSound {
            self.stopSound()
            self.currentSound = newSound
            activateAudioSession()
            self.currentSound?.play()
        }
    }
    
    private func activateAudioSession() {
        do {
            try audioSession.setActive(true)
        } catch {
            print(error)
        }
    }
    
    func togglePlaying() {
        
        if let currentSound = currentSound {
            
            if currentSound.isPlaying {
                currentSound.pause()
            } else {
                currentSound.play()
            }
        }
    }
    
    func pauseSound() {
        
        if let currentSound = currentSound { currentSound.pause() }
    }
    
    func resumeSound() {
        
        if let currentSound = currentSound { currentSound.play() }
    }
    
    func stopSound() {
        
        if let currentSound = self.currentSound {
            currentSound.stop()
        }
        
    }
    
    private func loadSoundFromFileName(_ filename:String?) -> AVAudioPlayer? {
        
        if let filename = filename {
            
            let url = Bundle.main.url(forResource: filename, withExtension: "wav")
            
            if let url = url {
                do {
                    return try AVAudioPlayer(contentsOf: url)
                } catch {
                    print("Couldn't load the sound")
                    print(error)
                }
            } else { print("Invalid URL in SoundProvider.loadSoundFromFileName") }
            
        }
        return nil
    }
}
