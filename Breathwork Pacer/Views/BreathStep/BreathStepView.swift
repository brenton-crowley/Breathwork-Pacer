//
//  BreathStepView.swift
//  Breathwork Pacer
//
//  Created by Brent on 8/3/2022.
//

import SwiftUI

struct BreathStepView: View {
    
    @State private var isEditing = false
    @State private var stepType:BreathStepType
    @State private var duration:Double
    
    init(stepType:BreathStepType, duration:Double) {
        self.stepType = stepType
        self.duration = duration
    }
    
    init() {
        self.stepType = BreathStepType.inhale
        self.duration = 6.0
    }
    
    var body: some View {
        
        ZStack {
            
            Background(stepType: $stepType)
                .onTapGesture {
                    isEditing.toggle()
                }
            
            ZStack {
                // Build both views but only display
                EditingView(stepType: $stepType, duration: $duration, isEditing: isEditing)
                    .opacity(isEditing ? 1 : 0)
//                    .offset(x: isEditing ? 0 : 100)
                    .scaleEffect(isEditing ? 1 : 0.8)
                
                DisplayView(stepTypeText: stepType.rawValue.capitalized,
                            duration: duration)
                    .opacity(isEditing ? 0.8 : 1)
//                    .offset(x: isEditing ? -100 : 0)
                    .blur(radius: isEditing ? 15 : 0)
            }
            .padding(.horizontal)
            .foregroundColor(.white)
            .animation(.easeInOut, value: isEditing)
            
            
            
        }
        .frame(height: 120)
        
    }
    
    struct Background:View {
        
        @Binding var stepType:BreathStepType
        
        var body: some View {
            Rectangle()
                .foregroundColor(colorForStepType())
            
        }
        
        func colorForStepType() -> Color {
            
            switch stepType {
            case .inhale:
                return Color.pink
            case .exhale:
                return Color.cyan
            case .rest:
                return Color.orange
            }
            
        }
    }
    
    struct DisplayView:View {
        
        let stepTypeText:String
        let duration:Double
        var durationString:String {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            
            return String(formatter.string(from: NSNumber(value:duration)) ?? "Nope")
            
        }
        
        var body: some View {
            HStack {
                Text(stepTypeText)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(.horizontal)
                Spacer()
                Text("\(durationString) Seconds")
                    .padding(.horizontal)
                    .font(.title)
                    .font(.system(.largeTitle, design: .rounded))
            }
        }
        
    }
    
    struct EditingView:View {
        
        @Binding var stepType:BreathStepType
        @Binding var duration:Double
        @FocusState var durationIsFocused: Bool
        let isEditing:Bool
        
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
                            .tag(BreathStepType.inhale)
                        Text(BreathStepType.exhale.rawValue.capitalized)
                            .tag(BreathStepType.exhale)
                        Text(BreathStepType.rest.rawValue.capitalized)
                            .tag(BreathStepType.rest)
                    }
                    .pickerStyle(.segmented)
                }
                
                // Duration
                HStack {
                    
                    Text("Duration:")
                        .font(.title)
                    TextField("Duration", value: $duration, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                    //                        .border(.blue, width: 1.0)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.black)
                        .focused($durationIsFocused)
                    
                    if durationIsFocused {
                        Button("Done") {
                            durationIsFocused = false
                        }
                    } else {
                        Stepper("", value: $duration, step: 0.1)
                    }
                    
                    
                }
            }
        }
        
    }
}



struct BreathStepView_Previews: PreviewProvider {
    static var previews: some View {
        BreathStepView(stepType: BreathStepType.inhale, duration: 6.0)
    }
}
