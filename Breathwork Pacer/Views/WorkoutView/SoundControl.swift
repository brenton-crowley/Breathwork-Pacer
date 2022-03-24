//
//  SoundControl.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import SwiftUI

struct SoundControl:View {
    
    private struct Constants {
        static let iconSize:CGSize = CGSize(width: 20, height: 20)
        static let zeroSpacing:CGFloat = 0
        static let hasSoundImage = "speaker.wave.3"
        static let noSoundImage = "speaker"
    }
    
    @EnvironmentObject var workoutModel:WorkoutViewModel
    
    @State var isEditing:Bool = false
    @State var selectedSoundType:SoundControlType = .yoga
    
    var body: some View {
        
        let container = HStack (spacing: Constants.zeroSpacing) {
            let soundType = workoutModel.workout.soundControlType
            let soundImage = soundType == .none ? Constants.noSoundImage : Constants.hasSoundImage
            Image(systemName: soundImage)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
                .padding(.trailing)
            
            if isEditing { editControl() } else { displayControl() }
        }
        
        container
            .padding(.horizontal)
            .onAppear {
                self.selectedSoundType = workoutModel.workout.soundControlType
            }
        
    }
    
    @ViewBuilder
    private func editControl() -> some View {
        HStack {
            Picker("", selection: $selectedSoundType) {
                ForEach(SoundControlType.allCases, id: \.self) { soundType in
                    Text(String(soundType.rawValue.capitalized))
                        .tag(soundType)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedSoundType) { newValue in
                // update viewModel to new sound
                workoutModel.changeSoundTypeTo(selectedSoundType)
            }
            
            
            Button("Done") {
                withAnimation {
                    isEditing = false
                }
            }
        }
    }
    
    @ViewBuilder
    private func displayControl() -> some View {
        Text(workoutModel.workout.soundControlType.rawValue.capitalized)
            .onTapGesture {
                withAnimation {
                    self.isEditing = true
                }
            }
    }
    
}


struct SoundControl_Previews: PreviewProvider {
    static var previews: some View {
        SoundControl()
            .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
            .environmentObject(WorkoutViewModel(breathSet: BreathSet.example))
    }
}
