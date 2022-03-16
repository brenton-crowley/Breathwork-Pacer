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
                
                Text("Select a sound prompt")
                    .font(.caption)
                SoundControl()
                    .padding([.horizontal, .bottom])
                // Timer
                TimerView(minutes: viewModel.getCountdownMinutes(), seconds: viewModel.getCountdownSeconds())
                    .padding(.vertical)
                // Animation - TabView as page with different animations that can be swiped
                BreathAnimationTabView(selectedAnimation: viewModel.workout.animationType)
                    .frame(width: geo.size.width * 0.6, height: geo.size.height * 0.35)
                    .padding()
                // Play/Pause Controls
                PlayControl()
                    .frame(width: geo.size.height * 0.15, height: geo.size.height * 0.15)
                    .padding()
                // Segmented control of sounds
                
                
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
        }
        .onDisappear {
            viewModel.pauseSession()
        }
    }
}

struct SoundControl:View {
    
    enum SoundControlType:String, CaseIterable {
        case none = "None",
             breath = "Breath",
             tone = "Tone"
//             count = "Count"
    }
    
    @State var selectedSoundType:SoundControlType = .none
    
    var body: some View {
        HStack {
            // Sound Icon
            let systemImage = selectedSoundType == .none ? "speaker" : "speaker.wave.3"
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 50, height: 50)
            // SegmentedControl
            Picker("", selection: $selectedSoundType) {
                ForEach(SoundControlType.allCases, id: \.self) { soundType in
                    Text(String(soundType.rawValue))
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
}

struct PlayControl:View {
    
    @EnvironmentObject private var viewModel:WorkoutViewModel
    
    var body: some View {
        
        if viewModel.workout.isPlaying {
            Button {
                // Pause the workout
                viewModel.pauseSession()
            } label: {
                ScalableSystemImageView(systemImageText: "pause.circle")
                    
            }

        } else {
            Button {
                // Play the workout
                viewModel.playSession()
            } label: {
                ScalableSystemImageView(systemImageText: "play.circle")
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

struct BreathAnimationTabView:View {
    
    @EnvironmentObject private var viewModel:WorkoutViewModel
    
    enum BreathAnimationType {
        case circleAnimationTag, boxAnimationTag, fadeAnimationTag
    }
    
    @State var selectedAnimation:BreathAnimationType
    var selectedColour:Color { viewModel.colorFromDescription(viewModel.workout.animationColor) }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedAnimation) {
                // Aniamtion View
                BreathAnimation(animationType: .circleAnimationTag)
                    .foregroundColor(selectedColour)
                    .tag(BreathAnimationType.circleAnimationTag)
                    .onTapGesture { viewModel.changeToNextColour() }
                    
                // Animation View
                BreathAnimation(animationType: .boxAnimationTag)
                    .foregroundColor(selectedColour)
                    .tag(BreathAnimationType.boxAnimationTag)
                    .onTapGesture { viewModel.changeToNextColour() }
                // Animation View
            }
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onChange(of: selectedAnimation) { newValue in
                // modify the view model
                viewModel.changeAnimationTypeTo(selectedAnimation)
            }
            
            Text("Inhale")
        }
    }
    
    struct BreathAnimation:View {
        
        let animationType:BreathAnimationType
        
        var body: some View {
            switch animationType {
            case .circleAnimationTag:
                Circle()
            case .boxAnimationTag:
                Rectangle()
            case .fadeAnimationTag:
                Rectangle()
            }
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
