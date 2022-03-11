//
//  Breathwork_PacerApp.swift
//  Breathwork Pacer
//
//  Created by Brent on 7/3/2022.
//

import SwiftUI

@main
struct Breathwork_PacerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            BreathStepView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
