//
//  BreathSetsView.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import SwiftUI

struct HomeWorkoutsListView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    @EnvironmentObject private var model:BreathSetsModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowingSheet = false
    
    var body: some View {
        
        // Navigation View
        NavigationView {
            // List of sets pulled from Core Data
            VStack {
                if let breathSets = model.breathSets, breathSets.count > 0 {
                    
                    let container = VStack(alignment: .center, spacing: 0) {
                        Text("Your Breath Workouts")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .padding()
                        List {
                            /// need to use the \.self id because the uuid for identifiable points to a reference
                            /// that's been deleted.
                            /// https://stackoverflow.com/questions/60604658/crash-when-delete-a-record-from-coredata-in-swiftui
                            ForEach(breathSets) { breathSet in
                                // Navigation Links
                                NavigationLink {
                                    let breathWorkout = breathWorkoutForBreathSet(breathSet)
                                    breathWorkout
                                } label: {
                                    Text(breathSet.title)
                                }.isDetailLink(false)
                            }
                            .onDelete(perform: model.deleteBreathSets)
                            
                        }
                        .padding(.top, -10)
                    }
                    
                    container
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                    Text("Add a Breath Workout")
                }
            }
            .toolbar {
                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        //toggle light/dark
//                        isDarkMode.toggle()
//                    } label: {
//                        let imageName = isDarkMode ? GlobalConstants.lightImage : GlobalConstants.darkImage
//                        Image(systemName: imageName)
//                    }
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Add Button
                    Button { isShowingSheet.toggle()
                    } label: { Image(systemName: "plus") }
                    .sheet(isPresented: $isShowingSheet) {
                        
                        AddStep(isShowingSheet: $isShowingSheet)
                            
                    }

                }
            }
            
            
        }
        
    }
    
    // MARK: - BreathSet View
    @ViewBuilder
    private func breathWorkoutForBreathSet(_ breathSet:BreathSet) -> some View {
        VStack {
            EditStepsView(breathSet: breathSet)
            
            let link = NavigationLink {
                WorkoutView()
                    .environmentObject(WorkoutViewModel(breathSet: breathSet))
                    .navigationTitle(breathSet.title)
            } label: {
                Label("Go to Session", systemImage: "clock")
                    .scaleEffect(1.5)
                    .padding(.vertical)
                    .buttonStyle(.plain)
            }
            link.isDetailLink(true)
            
                
        }
    }
    
}

struct BreathSetsView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeWorkoutsListView()
        .environmentObject(BreathSetsModel(storageProvider: StorageProvider.preview))
        .preferredColorScheme(.dark)
    }
}
