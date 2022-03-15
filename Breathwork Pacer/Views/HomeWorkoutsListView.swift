//
//  BreathSetsView.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import SwiftUI

struct HomeWorkoutsListView: View {
    
    @EnvironmentObject private var model:BreathSetsModel
    
    var body: some View {
        
        // Navigation View
        NavigationView {
            // List of sets pulled from Core Data
            if let breathSets = model.breathSets {
                VStack(alignment: .center, spacing: 0) {
                    Text("Choose a workout")
                        .font(.title)
                        .padding()
                    List {
                        
                        ForEach(breathSets) { breathSet in
                            // Navigation Links
                            NavigationLink {
                                // Will need to change to BreathSetView
//                                CoreDataBoilerPlateView(breathSet: breathSet)
                                // MARK: EditStepsView and Start Breathwork Button
                                VStack {
                                    EditStepsView(breathSet: breathSet)
                                    Button {
                                        // start the breathwork sesson
                                    } label: {
                                        Label("Go to Session", systemImage: "clock")
                                            .scaleEffect(1.5)
                                    }
                                    .padding(.top)
                                    .buttonStyle(.plain)
                                }
                            } label: {
                                Text(breathSet.title)
                            }
                        }
                        
                    }
                    .padding(.top, -10)
                }
                .navigationBarHidden(true)
                
            } else {
                Text("No Breath Sets")
            }
            
            
        }
    }
}

struct BreathSetsView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeWorkoutsListView()
        .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
//        .preferredColorScheme(.dark)
    }
}
