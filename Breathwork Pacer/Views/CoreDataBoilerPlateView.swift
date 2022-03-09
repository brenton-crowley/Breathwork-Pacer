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
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                LazyVStack {
                    ForEach(items) { item in
                        
                        let stepType = BreathStepType.stepTypeForString(item.type ?? "")
                        
                        BreathStepView(stepType: stepType, duration: Double(item.duration))
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
                        
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                Text("Select an item")
            }
            .navigationTitle("Steps")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = BreathStep(context: viewContext)
            newItem.id = UUID()
            
            let i = Int.random(in: BreathStepType.allCases.indices)
            newItem.type = BreathStepType.allCases[i].rawValue
            newItem.duration = Int.random(in: 1...6)
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
    }
}
