//
//  TimerView.swift
//  Breathwork Pacer
//
//  Created by Brent on 16/3/2022.
//

import SwiftUI

struct TimerView:View {
    
    @EnvironmentObject private var viewModel:WorkoutViewModel
    
    @State var isEditing:Bool = false
    @State var minutes:Int
    @State var seconds:Int
    
    var body: some View {
        
        VStack {
                
            if isEditing {
               
                EditTimerView(isEditing: $isEditing,
                              minutes: $minutes,
                              seconds: $seconds)
                
            } else {
                
                TimerDisplayView(isEditing: $isEditing,
                                 minutes: $minutes,
                                 seconds: $seconds)
            }
        }
    }
    
    struct TimerDisplayView: View {
        
        @EnvironmentObject private var viewModel:WorkoutViewModel
        @Binding var isEditing:Bool
        @Binding var minutes:Int
        @Binding var seconds:Int
        
        var body: some View {
            Text(String(format: "%02d:%02d", viewModel.getCountdownMinutes(), viewModel.getCountdownSeconds()))
                .font(.largeTitle)
                .onTapGesture {
                    if !viewModel.workout.isPlaying {
                        withAnimation {
                            isEditing = true
                            self.minutes = viewModel.getCountdownMinutes()
                            self.seconds = viewModel.getCountdownSeconds()
                        }
                    }
                }
                .transition(.scale)
        }
    }
    
    struct EditTimerView:View {
        
        @EnvironmentObject private var viewModel:WorkoutViewModel
        @Binding var isEditing:Bool
        @Binding var minutes:Int
        @Binding var seconds:Int
        
        var body: some View {
            HStack (alignment: .center, spacing: 0) {
                
                // TODO: - On reset or bookmark, reset the current step index to 0
                TimePicker(label: "Minutes", range: 0...60, value: $minutes)
                Text(" minutes : ")
                    .font(.caption)
                
                TimePicker(label: "Seconds", range: 0...60, value: $seconds)
                Text(" seconds")
                    .font(.caption)
                // Done Editing
                
                VStack {
                    // MARK: - Reset the Timer to the saved duration.
                    TimerPickerButton(systemImageName: "gobackward",
                                      newMinutes: viewModel.getDefaultMinutes(),
                                      newSeconds: viewModel.getDefaultSeconds(),
                                      isEditing: $isEditing) {

                        self.minutes = viewModel.getDefaultMinutes()
                        self.seconds = viewModel.getDefaultSeconds()
                    }
                    Spacer()
                    // MARK: - Save new Timer default duration
                    TimerPickerButton(systemImageName: "bookmark.circle",
                                      newMinutes: minutes,
                                      newSeconds: seconds,
                                      isEditing: $isEditing) {
//                        viewModel.setNewTotalDurationFromMinutes(minutes, seconds: seconds)
                        viewModel.saveDefaultTimerDuration(minutes, seconds)
                    }
                    Spacer()
                    // MARK: - Accept the current Time duration
                    TimerPickerButton(systemImageName: "checkmark.circle",
                                      newMinutes: minutes,
                                      newSeconds: seconds,
                                      isEditing: $isEditing)
                    
                }
                
            
            }
            .frame(width: 300, height: 200)
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke()
            }
            .transition(.scale)
        }
        
    }
    
    struct TimePicker:View {
        
        let label:String
        let range:ClosedRange<Int>
        @Binding var value:Int
        
        var body: some View {
            Picker(label, selection: $value) {
                ForEach(range, id: \.self) {
                    Text(String($0))
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(width: 70)
        }
        
    }

    struct TimerPickerButton:View {
        
        @EnvironmentObject private var viewModel:WorkoutViewModel
        
        let systemImageName:String
        let newMinutes:Int
        let newSeconds:Int
        @Binding var isEditing:Bool
        var action:(() -> Void)?
        
        var body: some View {
            
            Button {
                
                if let action = action {
                    action()
                } else {
                    withAnimation {
                        isEditing = false
                    }
                    viewModel.setNewTotalDurationFromMinutes(newMinutes, seconds: newSeconds)
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
