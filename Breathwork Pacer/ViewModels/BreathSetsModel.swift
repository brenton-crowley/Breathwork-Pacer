//
//  BreathSetsModel.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import SwiftUI

class BreathSetsModel: ObservableObject {
    
    private let viewContext = PersistenceController.shared.container.viewContext
    private var jsonBreathSets = [BreathSetJSON]()
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: Constants.sortOrderKey, ascending: true)
    ]) private var breathSets:FetchedResults<BreathSet>
    
    init() {
        // preload and parse json on first run
            // enable the ability to resotre model objects
        // convert json into core data objects
        preloadData()
    }
    
    func preloadData() {
        
        // Reset the store with preloaded data
        let resetStore = false
        if resetStore {
            viewContext.reset()
            UserDefaults.standard.setValue(false, forKey: Constants.dataIsPreloadedKey)
        }
        
        
        let status = UserDefaults.standard.bool(forKey: Constants.dataIsPreloadedKey)
       
        if !status {
            func loadAndParseJSON() {
                //BUDGD
                if let url = Bundle.main.url(forResource: "default_workouts", withExtension: "json") {
                    
                    do {
                        let data = try Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        
                        do {
                            self.jsonBreathSets = try decoder.decode([BreathSetJSON].self, from: data)
                            
                            // convert json into CoreData Objects
                            convertJSONToModels()
                        } catch {
                            print(error)
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                }
                
            }
            
            func convertJSONToModels() {
                
                // loop through the breath sets
                for jsonBreathSet in self.jsonBreathSets {
                    let breathSet = BreathSet(context: viewContext)
                    breathSet.id = UUID()
                    breathSet.title = jsonBreathSet.title
                    
                    for index in jsonBreathSet.steps.indices {
                        let jsonStep = jsonBreathSet.steps[index]
                        let breathStep = BreathStep(context: viewContext)
                        breathStep.id = UUID()
                        breathStep.type = jsonStep.type
                        breathStep.duration = jsonStep.duration
                        breathStep.sortOrder = index
                        breathStep.breathSet = breathSet
                        
                    }
                    
                }
                
                saveContextWithSuccess {
                    UserDefaults.standard.setValue(true, forKey: Constants.dataIsPreloadedKey)
                    print("Successfully preloaded and saved data into core data store upon first run.")
                }
            }
            
            loadAndParseJSON()
        }
    }
    
    func saveContextWithSuccess(_ runOnSuccess: () -> Void) {
        
        do {
            try viewContext.save()
            
            runOnSuccess()
        } catch {
            print(error)
        }
    }
}
