//
//  WorkoutView.swift
//  Breathwork Pacer
//
//  Created by Brent on 16/3/2022.
//

import SwiftUI

struct WorkoutView: View {
    
    
    
    // Fetch request of settings
    @Environment(\.scenePhase) var scenePhase
    
    var breaths:BreathSet
    @State var workoutModel:WorkoutViewModel?
    var breathSet:BreathSet? {
        
        guard let workoutModel = workoutModel else {
            return nil
        }
        
        return workoutModel.workout.breathSet
    }
    
    var body: some View {
        
        VStack {
            if let workoutModel = workoutModel {
                GeometryReader { geo in
                    // VStack
                    VStack (alignment: .center, spacing: 0) {
                        
                        // Timer
                        TimerView(minutes: workoutModel.getCountdownMinutes(), seconds: workoutModel.getCountdownSeconds())
                            .padding(.vertical)
                        Text(workoutModel.getStepActionText())
                        // Animation - TabView as page with different animations that can be swiped
                        BreathAnimationPageView(selectedAnimation: workoutModel.workout.animationType)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5)
                            .padding(.bottom)
                        // Play/Pause Controls
                        
                        // Segmented control of sounds
                        SoundControl()
                            .padding(.vertical)
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .toolbar {
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            
                            PlayControl()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                        
                    }
                    
                }
                .onDisappear {
                    workoutModel.pauseSession()
                }
                .onChange(of: scenePhase) { newPhase in
                    workoutModel.setNewScenePhase(newPhase)
                }
                .environmentObject(workoutModel)
            } else {
                EmptyView()
            }
            
        }
        .onAppear {
            self.workoutModel = WorkoutViewModel(breathSet: breaths)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            WorkoutView(breaths: BreathSet.example)
        }
        .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
        .navigationBarTitleDisplayMode(.inline)
    }
}
