//
//  WorkoutView.swift
//  Breathwork Pacer
//
//  Created by Brent on 16/3/2022.
//

import SwiftUI

struct WorkoutView: View {
    
    // Fetch request of settings
    
    @EnvironmentObject var viewModel:WorkoutViewModel
    
    var breathSet:BreathSet { viewModel.workout.breathSet }
    
    var body: some View {
        
        GeometryReader { geo in
            // VStack
            VStack (alignment: .center, spacing: 0) {
                
                /// For Testing
                /// Display the breath steps and their durations
//                VStack (alignment: .leading) {
//                    ForEach(self.viewModel.workout.steps) { step in
//                        let highlight:Color = self.viewModel.workout.currentStep.id == step.id ? .blue : .black
//
//                        Text("\(step.type.capitalized), \(step.duration)")
//                            .foregroundColor(highlight)
//                    }
//                }
                
                // Timer
                TimerView(minutes: viewModel.getCountdownMinutes(), seconds: viewModel.getCountdownSeconds())
                    .padding(.vertical)
                Text(viewModel.getStepActionText())
                // Animation - TabView as page with different animations that can be swiped
                BreathAnimationTabView(selectedAnimation: viewModel.workout.animationType)
                    .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5)
                    .padding(.bottom)
                // Play/Pause Controls
                
                // Segmented control of sounds
                SoundControl()
                    .padding(.vertical)
                
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            .toolbar {
                    
                PlayControl()
                    .aspectRatio(contentMode: .fit)
                
            }
            
        }
        .onDisappear {
            viewModel.pauseSession()
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            WorkoutView()
        }
        .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
        .environmentObject(WorkoutViewModel(breathSet: BreathSet.example))
        .navigationBarTitleDisplayMode(.inline)
//        .preferredColorScheme(.dark)
    }
}
