//
//  BreathAnimationTabView.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import SwiftUI

struct BreathAnimationTabView:View {
    
    @EnvironmentObject private var viewModel:WorkoutViewModel
    
    @State var selectedAnimation:BreathAnimationType
    
    var body: some View {
        VStack {
            TabView(selection: $selectedAnimation) {
                // Aniamtion View
                BreathAnimation(animationType: .circleAnimation)
                    
                    
                // Animation View
                BreathAnimation(animationType: .boxAnimation)
                    
                // Animation View
            }
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onChange(of: selectedAnimation) { newValue in
                // modify the view model
                viewModel.changeAnimationTypeTo(selectedAnimation)
            }
        }
    }
    
    struct BreathAnimation:View {
        
        @EnvironmentObject private var viewModel:WorkoutViewModel
        
        private var currentStep:BreathStep { self.viewModel.workout.currentStep }
        
        // only change if inhale or exhale
        
        let animationType:BreathAnimationType
        var selectedColour:Color {
            viewModel.colorFromDescription(viewModel.workout.animationColor)
        }
        
        
        var body: some View {
            let shape = getShapeToAnimation(animationType: animationType)
                .foregroundColor(selectedColour)
                .padding(.bottom, 55)
                .padding(.top)
                .tag(animationType)
                .onTapGesture { viewModel.changeToNextColour() }
            
            
                shape
                    .animation(.default, value: self.viewModel.workout.totalElapsedTime)
                
            
            
            // scale up animation
        }
        
        @ViewBuilder
        func getShapeToAnimation(animationType:BreathAnimationType) -> some View {
            
            let scaleSize = Animatables.getScaleValueForBreathStepWorkout(viewModel.workout)
            
            switch animationType {
            case .circleAnimation:
                CircleAnimation(scaleSize: scaleSize)
            case .boxAnimation:
                BoxAnimation(scaleSize: scaleSize)
            case .countAnimation:
                Rectangle()
            }
        }
    
        
    }

    struct CircleAnimation:View {
        
        let scaleSize:Double
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke()
                    .scaleEffect(0.99)
                Circle()
                    .scaleEffect(scaleSize)
            }
        }
        
    }
    
    struct BoxAnimation:View {
        
        let scaleSize:Double
        
        var body: some View {
            ZStack {
                Rectangle()
                    .stroke()
                    .scaleEffect(0.99)
                Rectangle()
                    .scaleEffect(y: scaleSize, anchor: .bottom)
            }
        }
        
    }
}


struct BreathAnimationTabView_Previews: PreviewProvider {
    static var previews: some View {
        BreathAnimationTabView(selectedAnimation: .boxAnimation)
            .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
            .environmentObject(WorkoutViewModel(breathSet: BreathSet.example))
    }
}
