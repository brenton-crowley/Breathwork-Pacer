//
//  BreathSet+CoreDataProperties.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//
//

import Foundation
import CoreData


extension BreathSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreathSet> {
        return NSFetchRequest<BreathSet>(entityName: "BreathSet")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var steps: NSSet?

}

// MARK: Generated accessors for steps
extension BreathSet {

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: BreathStep)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: BreathStep)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)

}

extension BreathSet : Identifiable {

}
