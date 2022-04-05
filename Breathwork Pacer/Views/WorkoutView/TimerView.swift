//
//  TimerView.swift
//  Breathwork Pacer
//
//  Created by Brent on 16/3/2022.
//

import SwiftUI

struct TimerView:View {
    
    private struct Constants {
        static let editingSize:CGSize = CGSize(width: 300, height: 200)
        static let cornerRadius:CGFloat = 20
        static let pickerWidth:CGFloat = 70
        static let timeRange:ClosedRange<Int> = 0...60
        
    }
    
    @EnvironmentObject private var workoutModel:WorkoutViewModel
    
    @State var isEditing:Bool = false
    @State var minutes:Int
    @State var seconds:Int
    
    var body: some View {
        
        VStack {
            if isEditing { editTimerView() } else { timerDisiplayView() }
        }
    }
    
    // MARK: - Timer Display View
    @ViewBuilder
    private func timerDisiplayView() -> some View {
        
        Text(String(format: "%02d:%02d", workoutModel.getCountdownMinutes(), workoutModel.getCountdownSeconds()))
            .font(.largeTitle)
            .onTapGesture {
                if !workoutModel.workout.isPlaying {
                    withAnimation {
                        isEditing = true
                        self.minutes = workoutModel.getCountdownMinutes()
                        self.seconds = workoutModel.getCountdownSeconds()
                    }
                }
            }
            .transition(.scale)
    }
    
    // MARK: - Edit Timer View
    @ViewBuilder
    private func editTimerView() -> some View {
        
        let container = HStack (alignment: .center, spacing: 0) {
            
            let minutesPicker = timePicker(labelText: "Minutes", range: Constants.timeRange, value: $minutes)
            let secondsPicker = timePicker(labelText: "Seconds", range: Constants.timeRange, value: $seconds)
            let cancelButton = timePickerButton(systemImageName: "xmark.circle") {
                withAnimation {
                    isEditing = false
                }
            }
            
            let doneButton = timePickerButton(systemImageName: "checkmark.circle") {
                withAnimation {
                    isEditing = false
                }
                workoutModel.setNewTotalDurationFromMinutes(minutes, seconds: seconds)
            }
            
            // View Builder Stack
            minutesPicker
            Text(" minutes")
                .font(.caption)
            
            secondsPicker
            Text(" seconds")
                .font(.caption)
            VStack {
                doneButton
                Spacer()
                cancelButton
            }
            
        }
        
        container
            .frame(width: Constants.editingSize.width, height: Constants.editingSize.height)
            .overlay {
                RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                    .stroke()
            }
            .transition(.scale)
        
    }
    
    // MARK: - Time Picker
    @ViewBuilder
    private func timePicker(labelText:String, range:ClosedRange<Int>, value:Binding<Int>) -> some View {
        Picker(labelText, selection: value) {
            ForEach(range, id: \.self) {
                Text(String($0))
            }
        }
        .pickerStyle(.wheel)
        .labelsHidden()
        .frame(width: Constants.pickerWidth)
    }
    
    // MARK: - Time Picker Button
    @ViewBuilder
    private func timePickerButton(systemImageName:String, action: (() -> Void)? = nil) -> some View {
        
        Button {
            
            if let action = action {
                action()
            }
            
        } label: {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
        }
        .padding()
//            .buttonStyle(.plain)
        
    }
}

/// This code was found online and is needed to fix a bug of the hit area of resized pickers.
/// When two pickers are placed side-by-side in an HStack, one overlaps the other
/// rendering the underlapping Picker useless.
extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = WorkoutViewModel(breathSet: BreathSet.example)
        
        TimerView(minutes: viewModel.getCountdownMinutes(), seconds: viewModel.getCountdownSeconds())
            .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
            .environmentObject(viewModel)
    }
}
