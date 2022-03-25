//
//  AddStep.swift
//  Breathwork Pacer
//
//  Created by Brent on 25/3/2022.
//

import SwiftUI

struct AddStep: View {
    
    private struct Constants {
        static let setBounds:ClosedRange<Int> = 1...4
    }
    
    @EnvironmentObject private var home:BreathSetsModel
    
    @Binding var isShowingSheet:Bool
    
    @State private var addTitleText:String = ""
    @State private var numberOfSteps:Int = 1
    
    var body: some View {
        let container = VStack(alignment: .leading, spacing: 0) {
            
            let toolbar = HStack {
                Button("Cancel") {
                    isShowingSheet.toggle()
                }
                Spacer()
                Button("Add Workout") {
                    // call the view model
                        // add the title
                    // dismiss
                    isShowingSheet.toggle()
                    home.addBreathSetWithTitle(addTitleText, initSteps: numberOfSteps)
                }
            }
            
            toolbar
                .padding(.vertical)
            Text("What's the name of the workout?")
                .font(.system(.title, design: .rounded))
                .multilineTextAlignment(.leading)
                .padding(.bottom)
            TextField("Workout Title", text: $addTitleText, prompt: Text("Triangle"))
                .padding()
                .background( Rectangle().stroke() )
            Stepper("Number of Steps: \(numberOfSteps)", value: $numberOfSteps, in: Constants.setBounds)
                .padding(.vertical)
            Spacer()
        }
        
        container
            .padding()
    }
}

struct AddStep_Previews: PreviewProvider {
    static var previews: some View {
        AddStep(isShowingSheet: Binding.constant(true))
    }
}
