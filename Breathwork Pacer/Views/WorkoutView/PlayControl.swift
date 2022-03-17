//
//  PlayControl.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import SwiftUI

struct PlayControl:View {
    
    @EnvironmentObject private var viewModel:WorkoutViewModel
    
    var body: some View {
        
        if viewModel.workout.isPlaying {
            Button {
                // Pause the workout
                viewModel.pauseSession()
            } label: {
                ScalableSystemImageView(systemImageText: "pause.fill")
                    
            }

        } else {
            Button {
                // Play the workout
                viewModel.playSession()
            } label: {
                ScalableSystemImageView(systemImageText: "play.fill")
            }
        }
        
    }
    
    struct ScalableSystemImageView:View {
        
        let systemImageText:String
        
        var body: some View {
            Image(systemName: systemImageText)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        
    }
    
}

struct PlayControl_Previews: PreviewProvider {
    static var previews: some View {
        PlayControl()
            .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
            .environmentObject(WorkoutViewModel(breathSet: BreathSet.example))
    }
}
