//
//  BreathAnimationPageView.swift
//  Breathwork Pacer
//
//  Created by Brent on 17/3/2022.
//

import SwiftUI

struct BreathAnimationPageView:View {
    
    private struct Constants {
        static let controlPadding:CGFloat = 55
        static let expandedShape:CGFloat = 0.99
        static let contractedShape:CGFloat = 0.0
    }
    
    @EnvironmentObject private var workoutModel:WorkoutViewModel
    
    @State var selectedAnimation:BreathAnimationType
    
    private var currentStep:BreathStep { workoutModel.workout.currentStep }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedAnimation) {
                // Aniamtion View
                breathAnimation(.circleAnimation)
                breathAnimation(.boxAnimation)
                // Animation View
            }
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onChange(of: selectedAnimation) { newValue in
                // modify the view model
                workoutModel.changeAnimationTypeTo(selectedAnimation)
            }
        }
    }
    
    @ViewBuilder
    private func breathAnimation(_ animationType:BreathAnimationType) -> some View {
        
        let selectedColour:Color = workoutModel.colorFromDescription(workoutModel.workout.animationColor)
        
        let shape = getShapeToAnimation(animationType: animationType)
            .foregroundColor(selectedColour)
            .padding(.bottom, Constants.controlPadding)
            .padding(.top)
            .tag(animationType)
            .onTapGesture { workoutModel.changeToNextColour() }
        
        
            shape
                .animation(.default, value: workoutModel.workout.totalElapsedTime)
        
    }
    
    @ViewBuilder
    func getShapeToAnimation(animationType:BreathAnimationType) -> some View {
        
        let scaleSize = Animatables.getScaleValueForBreathStepWorkout(workoutModel.workout)
        
        switch animationType {
        case .circleAnimation:
            circleAnimation(scaleSize: scaleSize)
        case .boxAnimation:
            boxAnimation(scaleSize: scaleSize)
        case .countAnimation:
            Rectangle()
        }
    }
    
    @ViewBuilder
    private func circleAnimation(scaleSize:CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke()
                .scaleEffect(Constants.expandedShape)
            Circle()
                .scaleEffect(scaleSize)
            Circle()
                .opacity(0)
        }
    }
    
    @ViewBuilder
    private func boxAnimation(scaleSize:CGFloat) -> some View {
        ZStack {
            Rectangle()
                .stroke()
                .scaleEffect(Constants.expandedShape)
            Rectangle()
                .scaleEffect(y: scaleSize, anchor: .bottom)
            Rectangle()
                .opacity(0)
        }
    }
}


struct BreathAnimationTabView_Previews: PreviewProvider {
    static var previews: some View {
        BreathAnimationPageView(selectedAnimation: .boxAnimation)
            .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
            .environmentObject(WorkoutViewModel(breathSet: BreathSet.example))
    }
}
