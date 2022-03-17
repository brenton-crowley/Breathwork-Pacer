//
//  Enums.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import Foundation

enum SoundControlType:String, CaseIterable {
    case none = "None",
         breath = "Breath",
         tone = "Tone",
         voice = "Voice"
}


enum BreathAnimationType:String {
    case circleAnimation, boxAnimation, countAnimation
}
