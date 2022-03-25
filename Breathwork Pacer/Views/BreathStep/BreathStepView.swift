//
//  BreathStepView.swift
//  Breathwork Pacer
//
//  Created by Brent on 8/3/2022.
//

import SwiftUI

extension Color {
    static let ui = Color.UI()
    static let labelColor = Color("labelColour")
    struct UI {
        let labelColor = Color(GlobalConstants.breathStepLabelColour)
    }
}

struct BreathStepView: View {
    
    private struct Constants {
        
        // Cell
        static let cellHeight:CGFloat = 120
        
        // Opacity
        static let opaque:CGFloat = 1
        static let transparent:CGFloat = 0
        
        // EditView
        static let offsetValue:CGFloat = 40
        static let activeValue:CGFloat = 0
        static let stepperChangeAmount:CGFloat = 0.1
        
    }
    
    @EnvironmentObject var home:BreathSetsModel
    
    @State private var isFocused = false
    @State var stepType:BreathStepType
    @State var duration:Double
    
    @FocusState var durationIsFocused: Bool
        
    let breathStepId:UUID
    let parentIsEditing:Bool
    let sortOrder:Int

    var body: some View {
        
        let container = ZStack {
            
            let background = Rectangle()
            let editingView = editingView()
            let displayText = "\(stepType.rawValue.capitalized)"
            let displayView = displayView(stepTypeText: displayText)
            
            background
                .foregroundColor(colorForStepType())
                .padding(.horizontal)
                .onTapGesture {
                    isFocused.toggle()
                }
            
            // content
            ZStack {
                // Build both views but only display
                editingView
                    .opacity(isFocused ? Constants.opaque : Constants.transparent)
                    .offset(y: isFocused ? Constants.activeValue : -Constants.offsetValue)
                    .padding(.horizontal)
                
                displayView
                    .opacity(isFocused ? Constants.transparent : Constants.opaque)
                    .offset(y: isFocused ? Constants.offsetValue : Constants.activeValue)
                    .foregroundColor(BreathSetsModel.colorScheme == .light ? .white : .black)
            }
            .padding(.horizontal)
            .animation(.easeInOut, value: isFocused)
        }
        
        container
            .frame(height: Constants.cellHeight)
        
    }
    
    // MARK: - Background Colour
    private func colorForStepType() -> Color {
        
        switch stepType {
        case .inhale:
            return Color.purple
        case .exhale:
            return Color.cyan
        case .rest:
            return Color.orange
        }
        
    }
    
    // MARK: - Display View
    @ViewBuilder
    private func displayView(stepTypeText:String) -> some View {
        
        HStack {
            
            Text(stepTypeText)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .padding(.horizontal)
                .foregroundColor(Color.labelColor)
            Spacer()
            Text("\(durationString()) \nseconds")
                .padding(.horizontal)
                .font(.system(.title3, design: .rounded))
                .foregroundColor(Color.labelColor)
        }
        .animation(.default, value: parentIsEditing)
        
    }
    
    // MARK: - Editing View
    @ViewBuilder
    private func editingView() -> some View {
        
        VStack (alignment: .leading) {
            
            // Step Type
            let stepTypeControl = HStack {
                
                let stepLabel = Text("Step Type: ")
                let breathTypeSegment = Picker("", selection: $stepType) {
                    
                    let inhaleText = Text(BreathStepType.inhale.rawValue.capitalized)
                    let exhaleText = Text(BreathStepType.exhale.rawValue.capitalized)
                    let restText = Text(BreathStepType.rest.rawValue.capitalized)
                    
                    inhaleText.tag(BreathStepType.inhale)
                    exhaleText.tag(BreathStepType.exhale)
                    restText.tag(BreathStepType.rest)
                }

                stepLabel
                    .font(.title3)
                    .foregroundColor(Color.labelColor)

                breathTypeSegment
                    .pickerStyle(.segmented)
                    .colorMultiply(.white)
                    .onChange(of: stepType) { newValue in
                        // TODO: call the view model to change the step type to the value that's selected.
                        home.updateBreathStepTypeTo(stepType.rawValue, forID: breathStepId)
                    }
            }
            // Duration
            let durationControl = HStack {
                
                let durationLabel = Text("Duration:")
                let durationTextfield = TextField("Duration", value: $duration, formatter: editingViewNumberFormatter())
                
                durationLabel
                    .font(.title3)
                    .foregroundColor(Color.labelColor)
                Spacer()
                durationTextfield
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .focused($durationIsFocused)
                
                // Trailing Control
                if durationIsFocused {
                    Button("Done") {
                        durationIsFocused = false
                    }
                    .buttonStyle(.plain)
                } else {
                    Stepper("", value: $duration, step: Constants.stepperChangeAmount)
                }
            }
            
            stepTypeControl
            durationControl
                .onChange(of: duration) { newValue in
                    home.updateBreathStepDurationTo(duration, forID: breathStepId)
                }
        }
        
    }
    
    private func durationString() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        
        return String(formatter.string(from: NSNumber(value:duration)) ?? "Nope")
    }
    
    private func editingViewNumberFormatter() -> NumberFormatter {
        let f = NumberFormatter()
            f.usesSignificantDigits = true
            f.minimumSignificantDigits = 2
            f.maximumSignificantDigits = 2
        return f
    }
    
}



struct BreathStepView_Previews: PreviewProvider {
    static var previews: some View {
        
        let breathSet = BreathSet.example
        let step:BreathStep = breathSet.steps?.allObjects.first! as! BreathStep
        let stepType = BreathStepType.stepTypeForString(step.type)
        BreathStepView(stepType: stepType, duration: step.duration, breathStepId: step.id!, parentIsEditing: false, sortOrder: 22)
        .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
            .preferredColorScheme(.dark)
    }
}
