//
//  BreathStepView.swift
//  Breathwork Pacer
//
//  Created by Brent on 8/3/2022.
//

import SwiftUI

struct BreathStepView: View {
    
    @State private var isParentEditing:Bool
    
    @State private var isFocused = false
    @State private var stepType:BreathStepType
    @State private var duration:Double
    
    
    init(stepType:BreathStepType, duration:Double, isFocused:Bool, isParentEditing:Bool) {
        self.stepType = stepType
        self.duration = duration
        self.isFocused = isFocused
        self.isParentEditing = isParentEditing
    }
    
    init(stepType:BreathStepType, duration:Double) {
        self.stepType = stepType
        self.duration = duration
        self.isFocused = false
        self.isParentEditing = false
    }
    
    init() {
        self.stepType = BreathStepType.inhale
        self.duration = 6.0
        self.isFocused = false
        self.isParentEditing = false
    }
    
    var body: some View {
    
        ZStack {
            
            Background(stepType: $stepType)
                .onTapGesture {
                    isFocused.toggle()
                }
            
            ZStack {
                // Build both views but only display
                EditingView(stepType: $stepType, duration: $duration, isEditing: isFocused)
                    .opacity(isFocused ? 1 : 0)
                    .offset(y: isFocused ? 0 : -40)
//                    .scaleEffect(isFocused ? 1 : 0.8)
                
                DisplayView(isParentEditing: isParentEditing,stepTypeText: stepType.rawValue.capitalized,
                            duration: duration)
                    .opacity(isFocused ? 0 : 1)
                    .offset(y: isFocused ? 40 : 0)
                    .foregroundColor(BreathSetsModel.colorScheme == .light ? .white : .black)
//                    .blur(radius: isFocused ? 15 : 0)
            }
            .padding(.horizontal)
            .animation(.easeInOut, value: isFocused)
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
        
        let isParentEditing:Bool
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
                    .font(.system(isParentEditing ? .title : .largeTitle, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(.horizontal)
                Spacer()
                Text("\(durationString) \nseconds")
                    .padding(.horizontal)
                    .font(.system(isParentEditing ? .title3 : .title2, design: .rounded))
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
                        .font(.title3)
                        .foregroundColor(BreathSetsModel.colorScheme == .light ? .white : .black)
                    Picker("", selection: $stepType) {
                        Text(BreathStepType.inhale.rawValue.capitalized)
                            .tag(BreathStepType.inhale)
                        Text(BreathStepType.exhale.rawValue.capitalized)
                            .tag(BreathStepType.exhale)
                        Text(BreathStepType.rest.rawValue.capitalized)
                            .tag(BreathStepType.rest)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.white)
                }
                
                // Duration
                HStack {
                    
                    Text("Duration:")
                        .font(.title3)
                        .foregroundColor(BreathSetsModel.colorScheme == .light ? .white : .black)
                    Spacer()
                    TextField("Duration", value: $duration, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                    //                        .border(.blue, width: 1.0)
                        .keyboardType(.decimalPad)
                        .focused($durationIsFocused)
                    if durationIsFocused {
                        Button("Done") {
                            durationIsFocused = false
                        }
                        .buttonStyle(.plain)
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
        BreathStepView(
            stepType: BreathStepType.inhale,
            duration: 6.0,
            isFocused: false,
            isParentEditing: false)
//            .preferredColorScheme(.dark)
    }
}
