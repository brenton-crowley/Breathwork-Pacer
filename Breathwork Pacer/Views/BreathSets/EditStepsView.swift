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
    
    let breathSet:BreathSet
    var steps:[BreathStep] {
        
        let breathSteps = breathSet.steps?.allObjects as! [BreathStep]
        return breathSteps.sorted(by: { $0.sortOrder < $1.sortOrder })
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            Text(breathSet.title)
                .font(.title)
                .padding(.bottom)
            
            List {
                ForEach(steps) { step in
                    ListRowStepView(step: step)
                }
            }
        }
        //        .listStyle(.plain)
        .padding(0)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    struct ListRowStepView:View {
        
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
                           duration: Double(step.duration),
                           breathStepId: step.id)
            .tag(step.id)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                
                Button {
                    // TODO: copy this item in core data
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                }
                .tint(.blue)
                Button {
                    // TODO: delete item in core data
                    
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
