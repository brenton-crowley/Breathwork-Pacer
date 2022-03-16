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
                
                HStack (alignment: .center, spacing: 0) {
                    
                    TimePicker(label: "Minutes", range: 0...60, value: $minutes)
                    Text(" minutes : ")
                        .font(.caption)
                    
                    TimePicker(label: "Seconds", range: 0...60, value: $seconds)
                    Text(" seconds")
                        .font(.caption)
                    // Done Editing
                    Button {
                        withAnimation {
                            isEditing = false
                        }
                        viewModel.setNewTotalDurationFromMinutes(minutes, seconds: seconds)
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }
                    .padding(.horizontal)
                    .scaleEffect(1.5)
                    .buttonStyle(.plain)


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
                        withAnimation {
                            isEditing = true
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
