//
//  BreathSet+PreviewProvider.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import Foundation
import CoreData

extension BreathSet {
    
    static var example: BreathSet {
        
        let context = StorageProvider.preview.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<BreathSet> = BreathSet.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)
        
        return (results?.first)!
    }
    
}
