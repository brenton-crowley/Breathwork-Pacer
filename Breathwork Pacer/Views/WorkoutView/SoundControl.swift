//
//  SoundControl.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import SwiftUI

struct SoundControl:View {
    
    @EnvironmentObject var viewModel:WorkoutViewModel
    
    @State var isEditing:Bool = false
    
    var body: some View {
        HStack (spacing: 0) {
            let soundType = viewModel.workout.soundControlType
            let systemImage = soundType == .none ? "speaker" : "speaker.wave.3"
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(.trailing)
            
            if isEditing {
                EditSoundControl(selectedSoundType: viewModel.workout.soundControlType,
                                 isEditing: $isEditing)
            } else {
                DisplaySoundControl()
                    .onTapGesture {
                        withAnimation {
                            self.isEditing = true
                        }
                    }
            }
        }
        .padding(.horizontal)
        
    }
    
    struct EditSoundControl:View {
        
        @EnvironmentObject var viewModel:WorkoutViewModel
        @State var selectedSoundType:SoundControlType
        @Binding var isEditing:Bool
        
        var body: some View {
            
            // Sound Icon
            
            // SegmentedControl
            HStack {
                Picker("", selection: $selectedSoundType) {
                    ForEach(SoundControlType.allCases, id: \.self) { soundType in
                        Text(String(soundType.rawValue))
                            .tag(soundType)
                    }
                }
                .pickerStyle(.segmented)
                .onAppear(perform: {
                    self.selectedSoundType = viewModel.workout.soundControlType
                })
                .onChange(of: selectedSoundType) { newValue in
                    // update viewModel to new sound
                    viewModel.changeSoundTypeTo(selectedSoundType)
                }
                
                
                Button("Done") {
                    withAnimation {
                        isEditing = false
                    }
                }
            }
        }
        
    }
    
    struct DisplaySoundControl:View {
        
        @EnvironmentObject var viewModel:WorkoutViewModel
        
        var body: some View {
            Text(viewModel.workout.soundControlType.rawValue.capitalized)
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
