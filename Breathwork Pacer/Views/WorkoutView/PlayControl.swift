//
//  PlayControl.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import SwiftUI

struct PlayControl:View {
    
    private struct Constants {
        static let pauseImage = "pause.fill"
        static let playImage = "play.fill"
    }
    
    @EnvironmentObject private var workoutModel:WorkoutViewModel
    
    var body: some View {
        
        if workoutModel.workout.isPlaying {
            systemImageControl(Constants.pauseImage) { workoutModel.pauseSession() }
        } else {
            systemImageControl(Constants.playImage) { workoutModel.playSession() }
        }
        
    }
    
    @ViewBuilder
    private func systemImageControl(_ imageName:String, onTap tapAction: @escaping () -> Void ) -> some View {
        
        Button {
            // Play the workout
            tapAction()
        } label: {
            Image(systemName: imageName)
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
