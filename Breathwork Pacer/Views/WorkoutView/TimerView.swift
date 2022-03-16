//
//  TimerView.swift
//  Breathwork Pacer
//
//  Created by Brent on 16/3/2022.
//

import SwiftUI

struct TimerView:View {
    
    @EnvironmentObject private var viewModel:WorkoutViewModel
    
    @State var isEditing:Bool = true
    @State var minutes:Int
    @State var seconds:Int
    
    var body: some View {
        
        VStack {
                
            if isEditing {
                
                HStack (alignment: .center, spacing: 0) {
                    
                    TimePicker(label: "Minutes", range: 0...60, value: $minutes)
                    Text(" minutes : ")
                        .font(.caption)
                    
                    TimePicker(label: "Seconds", range: 0...60, value: $seconds)
                    Text(" seconds")
                        .font(.caption)
                    // Done Editing
                    
                    VStack {
                        TimerPickerButton(systemImageName: "gobackward",
                                          newMinutes: viewModel.getDefaultMinutes(),
                                          newSeconds: viewModel.getDefaultSeconds(),
                                          isEditing: $isEditing) {

                            self.minutes = viewModel.getDefaultMinutes()
                            self.seconds = viewModel.getDefaultSeconds()
                        }
                        Spacer()
                        TimerPickerButton(systemImageName: "bookmark.circle",
                                          newMinutes: minutes,
                                          newSeconds: seconds,
                                          isEditing: $isEditing) {
                            viewModel.setNewTotalDurationFromMinutes(minutes, seconds: seconds)
                        }
                        Spacer()
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
                
            } else {
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
//        .animation(.easeInOut, value: isEditing)
        
        
        
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
            .buttonStyle(.plain)
            
        }
        
    }
    
}


extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = WorkoutViewModel(breathSet: BreathSet.example)
        
        TimerView(minutes: viewModel.getCountdownMinutes(), seconds: viewModel.getCountdownSeconds())
            .environmentObject(viewModel)
    }
}
