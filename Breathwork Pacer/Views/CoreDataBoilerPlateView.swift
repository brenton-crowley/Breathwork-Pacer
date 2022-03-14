//
//  ContentView.swift
//  Breathwork Pacer
//
//  Created by Brent on 7/3/2022.
//

import SwiftUI
import CoreData

struct CoreDataBoilerPlateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "sortOrder", ascending: true)],
        animation: .default)
    private var items: FetchedResults<BreathStep>
    
    @State private var editMode:EditMode = .inactive
//    @FocusState private var focusedStep:Bool
    
    @State private var focusedID:UUID?
    
    var body: some View {
        NavigationView {
            
            
            VStack {
                List {
                    
                    let insets = EdgeInsets.init(top: 1,
                                                 leading: self.editMode == .inactive ? 0 : 10,
                                                 bottom: 1,
                                                 trailing: self.editMode == .inactive ? 0 : 10)
                    
                    ForEach(items) {step in
                        
                        // use breathstepcell
                        
                        let stepType = BreathStepType.stepTypeForString(step.type)
                        let isParentEditing = editMode != .active
                        
                        BreathStepView(stepType: stepType,
                                       duration: Double(step.duration),
                                       isFocused: (focusedID == step.id),
                                       isParentEditing: isParentEditing)
                            .tag(step.id)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                
    //                            Button {
    //                                // focus this item
    //                                self.focusedID = step.id
    //                            } label: {
    //                                Label("Edit", systemImage: "pencil")
    //                            }
    //                            .tint(.purple)
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
                    .onMove(perform: moveItem)
                    .onDelete(perform: deleteStep)
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .border(.red, width: 1.0)
                .navigationTitle("Steps")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    // MARK: - Add Multiple list items to Navigation Bar
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        EditButton()
                        
                        Button {
                            // TODO: Add Step to List
                            
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding(.trailing)
                    }
                }
            .environment(\.editMode, $editMode)
                Button {
                    // start the breathwork sesson
                } label: {
                    Label("Go to Session", systemImage: "clock")
                        .scaleEffect(1.5)
                }
                .padding(.top)
                .buttonStyle(.plain)

            }
        }
    }
    
    func moveItem(from source: IndexSet, to destination:Int) {
        //        breathSteps.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteStep(at offsets: IndexSet) {
        //        breathSteps.remove(atOffsets: offsets)
    }
    
    func addStep(_ step:BreathStep) {
        //        self.breathSteps.append(step)
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = BreathStep(context: viewContext)
            newItem.id = UUID()
            
            let i = Int.random(in: BreathStepType.allCases.indices)
            newItem.type = BreathStepType.allCases[i].rawValue
            newItem.duration = Double.random(in: 1.0...6.0)
            newItem.sortOrder = 0
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataBoilerPlateView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
