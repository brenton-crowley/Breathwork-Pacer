//
//  Breathwork_PacerApp.swift
//  Breathwork Pacer
//
//  Created by Brent on 7/3/2022.
//

import SwiftUI

@main
struct Breathwork_PacerApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    @StateObject private var storageProvider = StorageProvider()
    
    @State private var tintColor = Settings.shared.colorFromDescription(Settings.shared.defaultColor)
    
    var body: some Scene {
        WindowGroup {

            HomeWorkoutsListView()
                .environmentObject(storageProvider)
                .preferredColorScheme(.dark)
                .environmentObject(BreathSetsModel(storageProvider: storageProvider))
        }
    }
}
