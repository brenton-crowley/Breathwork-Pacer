//
//  BreathStep+CoreDataProperties.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//
//

import Foundation
import CoreData


extension BreathStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreathStep> {
        return NSFetchRequest<BreathStep>(entityName: "BreathStep")
    }

    @NSManaged public var duration: Double
    @NSManaged public var id: UUID?
    @NSManaged public var sortOrder: Int
    @NSManaged public var type: String
    @NSManaged public var breathSet: BreathSet

}

extension BreathStep : Identifiable {

}
