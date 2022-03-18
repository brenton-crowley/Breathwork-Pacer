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
            
            UserDefaults.standard.setValue(false, forKey: Constants.dataIsPreloadedKey)
        }
        
        
        let status = UserDefaults.standard.bool(forKey: Constants.dataIsPreloadedKey)
       
        if !status {
            self.storageProvider.loadAndParseJSONOnSuccess {
                UserDefaults.standard.setValue(true, forKey: Constants.dataIsPreloadedKey)
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
}
