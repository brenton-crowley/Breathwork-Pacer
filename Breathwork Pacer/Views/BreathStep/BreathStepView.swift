//
//  BreathStepView.swift
//  Breathwork Pacer
//
//  Created by Brent on 8/3/2022.
//

import SwiftUI

struct BreathStepView: View {
    
    @State private var isEditing = true
    
    var body: some View {
        
        ZStack {
            
            Background()
            if isEditing {
                EditingView()
            } else {
                DisplayView()
            }
            
            
        }
        .frame(height: 200)
        
    }
    
    struct Background:View {
        
        var body: some View {
            Rectangle()
                .opacity(0.1)
        }
    }
    
    struct DisplayView:View {
        
        var body: some View {
            HStack {
                Text("Inhale")
                    .padding(.horizontal)
                    .font(.largeTitle)
                Spacer()
                Text("4.8 Seconds")
                    .padding(.horizontal)
                    .font(.title)
            }
        }
        
    }
    
    struct EditingView:View {
        
        @State private var stepType = BreathStepType.inhale.rawValue
        @State private var duration = 1.0
        
        var formatter: NumberFormatter {
            
            let f = NumberFormatter()
            f.usesSignificantDigits = true
            f.minimumSignificantDigits = 2
            f.maximumSignificantDigits = 2
            return f
        }
        
        var body: some View {
            VStack (alignment: .leading) {
                
                // Step Type
                HStack {
                    Text("Step Type: ")
                        .font(.title)
                    Picker("", selection: $stepType) {
                        Text(BreathStepType.inhale.rawValue.capitalized)
                            .tag(BreathStepType.inhale.rawValue)
                        Text(BreathStepType.exhale.rawValue.capitalized)
                            .tag(BreathStepType.exhale.rawValue)
                        Text(BreathStepType.pause.rawValue.capitalized)
                            .tag(BreathStepType.pause.rawValue)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Duration
                HStack {
                    
                    Text("Duration:")
                        .font(.title)
                    
                    TextField("Duration", value: $duration, formatter: formatter)
                        .border(.blue, width: 1.0)
                    Stepper("", value: $duration, step: 0.1)
                    
                }
            }
            .padding(.horizontal)
        }
        
    }
}



struct BreathStepView_Previews: PreviewProvider {
    static var previews: some View {
        BreathStepView()
    }
}
