//
//  EditStepsView.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import SwiftUI

struct EditStepsView: View {
    // will fetch steps from a view model
    
    private struct Constants {
        
        static let leadingEdgeInset:CGFloat = 20
        static let topEdgeInset:CGFloat = 20
        static let trailingEdgeInset:CGFloat = 20
        static let bottomEdgeInset:CGFloat = 0
        static let animationDuration:CGFloat = 0.2
        
        // Padding and Spacing Constants
        static let noSpacing:CGFloat = 0
        static let noPadding:CGFloat = 0
        static let minorPadding:CGFloat = 2
        static let rowPadding:CGFloat = 10
    }
    
    @EnvironmentObject private var model:BreathSetsModel
    
    @State var editMode:EditMode = .inactive
    
    let breathSet:BreathSet
    var steps:[BreathStep] {
        
        let breathSteps = breathSet.steps?.allObjects as! [BreathStep]
        return breathSteps.sorted(by: { $0.sortOrder < $1.sortOrder })
    }
    
    var body: some View {
        
        let container = VStack(alignment: .center, spacing: Constants.noSpacing) {
            
            let title = Text(breathSet.title)
            
            let list = List {
                ForEach(steps) { step in
                    listItemWithStep(step)
                }
                .onMove(perform: self.model.move)
                .onDelete(perform: self.model.delete)
            }
            
            title
                .font(.title)
                .padding(.bottom)
            list
        }
        
        container
            .listStyle(.plain)
            .padding(Constants.noPadding)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                    // Add Button
                    Button {
                        // Action
                        self.model.addStepInSteps(steps, forBreathSet: breathSet)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }.environment(\.editMode, $editMode)
    }
    
    @ViewBuilder
    private func listItemWithStep(_ step:BreathStep) -> some View {
        
        let stepType = BreathStepType.stepTypeForString(step.type)
        let view = BreathStepView(stepType: stepType,
                                  duration: Double(step.duration),
                                  breathStepId: step.id,
                                  parentIsEditing: (editMode == .active))
        
        view
            .tag(step.id)
            .listRowInsets(listRowInsets())
            .animation(.easeOut(duration: Constants.animationDuration), value: editMode)
        //            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
        //
        //                Button {
        //                    // TODO: copy this item in core data
        //                } label: {
        //                    Label("Copy", systemImage: "doc.on.doc")
        //                }
        //                .tint(.blue)
        //                Button {
        //                    // TODO: delete item in core data
        //
        //                } label: {
        //                    Label("Delete", systemImage: "trash.fill")
        //                }
        //                .tint(.red)
        //
        //            }
        
    }
    
    private func listRowInsets() -> EdgeInsets {
        EdgeInsets.init(top: Constants.bottomEdgeInset,
                        leading: Constants.leadingEdgeInset,
                        bottom: Constants.bottomEdgeInset,
                        trailing: Constants.trailingEdgeInset)
    }
}


struct EditStepsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NavigationView {
            EditStepsView(breathSet: BreathSet.example)
                .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
                .preferredColorScheme(.dark)
            
        }
    }
}
