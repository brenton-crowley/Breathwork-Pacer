//
//  Settings.swift
//  Breathwork Pacer
//
//  Created by Brent on 18/3/2022.
//

import Foundation

class Settings {
    
    static let shared = Settings()
    
    private(set) var defaultTimer:Int
    private(set) var defaultColor:String
    private var defaultAnimation:String
    private var defaultSound:String
    
    var defaultAnimationType:BreathAnimationType { return BreathAnimationType.animationTypeForString(self.defaultAnimation) }
    var defaultSoundType:SoundControlType { return SoundControlType.soundTypeForString(self.defaultSound) }
    
    private init() {
        
        let defaults = UserDefaults.standard
        
        if let values = Settings.readPropertyList() {
            defaults.register(defaults: values)
        }
        
        self.defaultTimer = defaults.integer(forKey: GlobalConstants.defaultTimerDurationKey)
        self.defaultColor = defaults.string(forKey: GlobalConstants.defaultColorKey) ?? "blue"
        self.defaultAnimation = defaults.string(forKey: GlobalConstants.defaultAnimationKey) ?? BreathAnimationType.circleAnimation.rawValue
        self.defaultSound = defaults.string(forKey: GlobalConstants.defaultSoundKey) ?? SoundControlType.none.rawValue
    }
        
    static private func readPropertyList() -> [String: Any]? {
        guard let plistPath = Bundle.main.path(forResource: "settings", ofType: "plist"),
                let plistData = FileManager.default.contents(atPath: plistPath) else {
            return nil
        }
            
        return try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any]
    }
    
    func saveDefaultTimerTo(_ value:Int) {
        UserDefaults.standard.setValue(value, forKey: GlobalConstants.defaultTimerDurationKey)
        self.defaultTimer = value
    }
    
    func saveDefaultColorTo(_ value:String) {
        UserDefaults.standard.setValue(value, forKey: GlobalConstants.defaultColorKey)
        self.defaultColor = value
    }
    
    func saveDefaultAnimationTo(_ value:String) {
        UserDefaults.standard.setValue(value, forKey: GlobalConstants.defaultAnimationKey)
        self.defaultAnimation = value
    }
    
    func saveDefaultSoundTo(_ value:String) {
        UserDefaults.standard.setValue(value, forKey: GlobalConstants.defaultSoundKey)
        self.defaultSound = value
    }
    
}
