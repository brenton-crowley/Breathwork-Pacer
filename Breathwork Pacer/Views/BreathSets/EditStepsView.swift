//
//  EditStepsView.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import SwiftUI

struct EditStepsView: View {
    // will fetch steps from a view model
    
    @EnvironmentObject private var model:BreathSetsModel
    
    var breathSet:BreathSet?
    
    var body: some View {
        
        // TODO: - Bug here in the preview. Not Production code. Just want to preview a breath set
        let data = breathSet
        
        if let breathSet = data {

            VStack {
                
                Text(breathSet.title)
                    .font(.title)
                
                List {
                    let steps = breathSet.steps?.allObjects as! [BreathStep]
                    ForEach(steps) { step in
                        LocalStepView(step: step)
                    }
                    
                }
                
            }
            .padding(0)
            .navigationBarTitleDisplayMode(.inline)

        } else {
            Text("Couldn't load a breath set.")
        }
        
    }
    struct LocalStepView:View {
        
        let editMode:EditMode = .inactive
        let step:BreathStep
        var insets:EdgeInsets { return EdgeInsets.init(top: 1,
                                                  leading: editMode == .inactive ? 0 : 0,
                                                  bottom: 1,
                                                  trailing: editMode == .inactive ? 0 : 0)
            
        }
        
        var body: some View {
            
            let stepType = BreathStepType.stepTypeForString(step.type)
            
            BreathStepView(stepType: stepType,
                           duration: Double(step.duration))
                .tag(step.id)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    
                    Button {
                        // copy this item
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .tint(.blue)
                    Button {
                        // delete item
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    .tint(.red)
                    
                }
                .listRowInsets(insets)
                .animation(.easeOut(duration: 0.2), value: editMode)
            
        }
        
    }
}


struct EditStepsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        
        EditStepsView(breathSet: BreathSet.example)
        .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
//        .preferredColorScheme(.dark)
    }
}
