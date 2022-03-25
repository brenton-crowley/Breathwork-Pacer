//
//  BreathSetsModel.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import Foundation
import CoreData
import SwiftUI

class BreathSetsModel: ObservableObject {
    
    @Environment(\.colorScheme) static var colorScheme
    
    private let storageProvider:StorageProvider
    private let viewContext:NSManagedObjectContext
    private var jsonBreathSets = [BreathSetJSON]()
    private let isResetStore = false // set to true to reset the persistent store with default data. Will delete any existing data
    @Published private(set) var breathSets:[BreathSet]?
    
    init(storageProvider:StorageProvider = StorageProvider()) {
        
        self.storageProvider = storageProvider
        self.viewContext = self.storageProvider.persistentContainer.viewContext
        
        preloadData()
        fetchBreathSets()
    }
    
    func preloadData() {
        
        // Reset the store with preloaded data
        if isResetStore {
            
            func batchDeleteEntityName(_ entityName:String) {
            
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try self.storageProvider.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: self.viewContext)
                } catch {
                    print(error)
                }
            }
            
            batchDeleteEntityName("BreathSet")
            batchDeleteEntityName("BreathStep")
            
            UserDefaults.standard.setValue(false, forKey: GlobalConstants.dataIsPreloadedKey)
        }
        
        
        let status = UserDefaults.standard.bool(forKey: GlobalConstants.dataIsPreloadedKey)
       
        if !status {
            self.storageProvider.loadAndParseJSONOnSuccess {
                UserDefaults.standard.setValue(true, forKey: GlobalConstants.dataIsPreloadedKey)
                print("Successfully preloaded and saved data into core data store upon first run.")
                self.fetchBreathSets()
                print(self.breathSets!)
            }
        }
    }
    
    func fetchBreathSets() {

//      will need to change this. Move to the storage provider potentially.
        self.breathSets = self.storageProvider.breathSets
    }
    
    // MARK: - BreathStep Core Data Modifications
    func updateBreathStepDurationTo(_ duration:Double, forID id:UUID) {
        
        if let step = storageProvider.breathStepForId(id) {
            step.duration = duration
            storageProvider.updateStep()
            print("Saved duration to \(duration)")
        }
    }
    
    func updateBreathStepTypeTo(_ type:String, forID id:UUID) {
        
        if let step = storageProvider.breathStepForId(id) {
            step.type = type
            storageProvider.updateStep()
            print("Saved type to \(type)")
        }
    }
    
    func move(from offsets: IndexSet, destination: Int, steps:[BreathStep]) {
        
        let startIndex = offsets.first!
        var targetIndex = startIndex
        
        // moving from smaller to larger, set the targetIndex
        if startIndex < destination - 1 { targetIndex = destination - 1 }
        // moving from large to small, set the target Index
        else if startIndex >  destination { targetIndex = destination }
        
        // if the target index is the same as the start index, early exit.
        guard startIndex != targetIndex else { return }
        
        // otherwise, rearrange the steps and reset the sortOrder property
        let rearrangedSteps:[BreathStep] = rearrange(array: steps, fromIndex: startIndex, toIndex: targetIndex)
        rearrangedSteps.indices.forEach { rearrangedSteps[$0].sortOrder = $0 }
        
        storageProvider.updateBreathSet()
    }
    
    // candidate for an array extension
    private func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex:Int) -> Array<T> {
        
        var a = array
        let element = a.remove(at: fromIndex) // remove and store the element
        a.insert(element, at: toIndex) // reinsert the element
        return a
    }
    
    
    func delete(fromOffsets offsets: IndexSet, steps:[BreathStep]) {
        
        guard steps.count > 0 else { return }
        
        var breathSet:BreathSet?
        
        // delete the step
        offsets.map {steps[$0]}.forEach { step in
            breathSet = step.breathSet
            storageProvider.deleteStep(step)
        }
        
        if let breathSet = breathSet {
            var s = breathSet.steps?.allObjects as! [BreathStep]
            s.sort { $0.sortOrder < $1.sortOrder }
            s.indices.forEach { s[$0].sortOrder = $0 }

            storageProvider.updateBreathSet()
        }
    }
    
    func addStepInSteps(_ steps:[BreathStep], forBreathSet breathSet:BreathSet) {
        let index = steps.count
        let step = generateBreathStepAtIndex(index)
        step.breathSet = breathSet
        
        storageProvider.saveBreathSet(breathSet)
    }
    
    func addStepAtIndex(_ index:Int, toBreathSet breathSet:BreathSet) {
        // provide the breath step
        let step = generateBreathStepAtIndex()
        // loop through all the steps in breath steps from the current step
        var steps = breathSet.steps?.allObjects as! [BreathStep]
        
        if steps.count > 0 {
            steps.sort { $0.sortOrder < $1.sortOrder }
            
            // start at the index proided - 1
            // change the sort orders of the indexes
            
            for i in index..<steps.count {
                let s = steps[i]
                s.sortOrder = i + 1
            }
        }
        
        
        breathSet.addToSteps(step)
        storageProvider.saveBreathSet(breathSet)
    }
    
    func generateBreathStepAtIndex(_ index:Int = 0) -> BreathStep {
        let step = BreathStep(context: viewContext)
        step.id = UUID()
        step.duration = 3.0
        step.type = BreathStepType.inhale.rawValue
        step.sortOrder = index
        return step
    }
    
    func addStepToBreathSet(_ breathSet:BreathSet) {
        
        if let steps = breathSet.steps {
            addStepAtIndex(steps.allObjects.count, toBreathSet: breathSet)
        } else {
            addStepAtIndex(0, toBreathSet: breathSet)
        }
        
    }
}
