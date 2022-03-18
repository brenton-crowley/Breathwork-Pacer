//
//  StorageProvider.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import CoreData
import Foundation

class StorageProvider: ObservableObject {
    
    @Published private(set) var breathSets: [BreathSet] = []
    private var jsonBreathSets:[BreathSetJSON] = []
    
    let persistentContainer: NSPersistentContainer
    
    static var preview: StorageProvider = {
        
        let storageProvider = StorageProvider(inMemory: true)
        
        // create the test objects
        
        let breathSet = BreathSet(context: storageProvider.persistentContainer.viewContext)
        breathSet.id = UUID()
        breathSet.sortOrder = 0
        breathSet.title = "Storage Provider Data"
        
        
        /// Generate random elements
//        for index in 0..<4 {
//            let newItem = BreathStep(context: storageProvider.persistentContainer.viewContext)
//            newItem.id = UUID()
//
//            let i = Int.random(in: BreathStepType.allCases.indices)
//            newItem.type = BreathStepType.allCases[i].rawValue
//            newItem.duration = Double.random(in: 1.0...6.0)
//            newItem.sortOrder = index
//            newItem.breathSet = breathSet
//
//        }
        
        /// Generate a standard breath set to test
        
        func createBreathStep(type:BreathStepType, duration:Double, sortOrder:Int, breathSet:BreathSet) {
            let newItem = BreathStep(context: storageProvider.persistentContainer.viewContext)
            newItem.id = UUID()
            newItem.type = type.rawValue
            newItem.duration = duration
            newItem.sortOrder = sortOrder
            newItem.breathSet = breathSet
        }
        
        createBreathStep(type: .inhale,
                         duration: 3.0,
                         sortOrder: 0,
                         breathSet: breathSet)
        createBreathStep(type: .rest,
                         duration: 2.0,
                         sortOrder: 1,
                         breathSet: breathSet)
        createBreathStep(type: .exhale,
                         duration: 3.0,
                         sortOrder: 2,
                         breathSet: breathSet)
        createBreathStep(type: .rest,
                         duration: 1.0,
                         sortOrder: 3,
                         breathSet: breathSet)
//        storageProvider.loadAndParseJSONOnSuccess {
//
//        }
        
        // save them
        storageProvider.breathSets = storageProvider.getAllBreathSets()
        
        do {
            try storageProvider.persistentContainer.viewContext.save()
        } catch {
            print("Failed to save Breath Sets: \(error)")
        }
        
        return storageProvider
    }()
    
    init(inMemory:Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "Breathwork_Pacer")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Attempt to load persistent stores (the underlying storage of data)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                
                // For now, any failure to load the model is a programming error, and not recoverable
                fatalError("Core Data store failed to load with error: \(error)")
            } else {
                
                print("Successfully loaded persistent stores.")
                
                // Get all the movies
                self.breathSets = self.getAllBreathSets()
            }
            
        }
        
    }
    
    func loadAndParseJSONOnSuccess(_ onSuccess: () -> Void) {
        //BUDGD
        if let url = Bundle.main.url(forResource: "default_workouts", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                do {
                    self.jsonBreathSets = try decoder.decode([BreathSetJSON].self, from: data)
                    
                    // convert json into CoreData Objects
                    convertJSONToModels(onSuccess)
                } catch {
                    print(error)
                }
                
                
            } catch {
                print(error)
            }
        }
        
    }
    
    private func convertJSONToModels(_ onSuccess: () -> Void) {
        
        // loop through the breath sets
        for i in self.jsonBreathSets.indices {
            let jsonBreathSet = self.jsonBreathSets[i]
            let breathSet = BreathSet(context: self.persistentContainer.viewContext)
            breathSet.id = UUID()
            breathSet.title = jsonBreathSet.title
            breathSet.sortOrder = i
            
            for j in jsonBreathSet.steps.indices {
                let jsonStep = jsonBreathSet.steps[j]
                let breathStep = BreathStep(context: self.persistentContainer.viewContext)
                breathStep.id = UUID()
                breathStep.type = jsonStep.type
                breathStep.duration = jsonStep.duration
                breathStep.sortOrder = j
                breathStep.breathSet = breathSet
                
            }
        }
        
        
        saveContextWithSuccess {
            self.breathSets = getAllBreathSets()
            onSuccess()
        }
    }
    
    func saveContextWithSuccess(_ runOnSuccess: () -> Void) {
        
        do {
            try self.persistentContainer.viewContext.save()
            
            runOnSuccess()
        } catch {
            print(error)
        }
    }
    
}

extension StorageProvider {
    
    // Save new BreathSet
    func saveBreathSet(_ breathSet: BreathSet) {
        
        do {
            
            // Persist the data in this managed object context to the underlying store
            try persistentContainer.viewContext.save()
            
            print("Movie saved successfully")
            
            // Refresh the list of movies
            self.breathSets = getAllBreathSets()
            
        } catch {
            
            // Something went wrong 😭
            print("Failed to save movie: \(error)")
            
            // Rollback any changes in the managed object context
            persistentContainer.viewContext.rollback()
            
        }
        
    }

}

// Delete a movie
extension StorageProvider {
    
    func deleteBreathSets(at offsets: IndexSet) {
        for offset in offsets {
            let setToDelete = breathSets[offset]
            deleteBreathSet(setToDelete)
        }
    }
    
    func deleteBreathSet( _ breathSet: BreathSet) {
        
        persistentContainer.viewContext.delete(breathSet)
        
        do {
            
            try persistentContainer.viewContext.save()
            
            print("BreathSet Deleted deleted.")
            
            // Refresh the list of movies
            breathSets = getAllBreathSets()
            
        } catch {
            
            persistentContainer.viewContext.rollback()
            print("Failed to save context: \(error)")
            
        }
        
    }
    
}

// Update a BreathSet
extension StorageProvider {
    
    func updateBreathSet() {
        
        do {
            // Tell SwiftUI that the list of breath sets is being modified
            objectWillChange.send()
            
            // Actually persist/save the changes to the managed object context
            try persistentContainer.viewContext.save()
            print("BreathSet updated.")
            
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context: \(error)")
        }
        
    }
    
}


// Get all the BreathSets
extension StorageProvider {
    
    // Made private because views will access the movies retrieved from Core Data via the movies array in StorageProvider
    private func getAllBreathSets() -> [BreathSet] {
        
        // Must specify the type with annotation, otherwise Xcode won't know what overload of fetchRequest() to use (we want to use the one for the Movie entity)
        // The generic argument <Movie> allows Swift to know what kind of managed object a fetch request returns, which will make it easier to return the list of movies as an array
        let fetchRequest: NSFetchRequest<BreathSet> = BreathSet.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.sortOrderKey, ascending: true)]
        
        do {
            
            // Return an array of Movie objects, retrieved from the Core Data store
            return try persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch {
            
            print("Failed to fetch breath sets \(error)")
            
        }
        
        // If an error occured, return nothing
        return []
    }
}

// BreatStep Access
extension StorageProvider {
    
    func breathStepForId(_ id:UUID) -> BreathStep? {
        
        var step:BreathStep?
        
        let fetchRequest: NSFetchRequest<BreathStep> = BreathStep.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            step = try persistentContainer.viewContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        return step
    }
    
    func updateStep() {
        
        do {
            // Tell SwiftUI that the list of steps is being modified
            objectWillChange.send()
            
            // Actually persist/save the changes to the managed object context
            try persistentContainer.viewContext.save()
            print("BreathSet updated.")
            
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context: \(error)")
        }
        
    }
}
