//
//  CDCar+CoreDataProperties.swift
//  Car
//
//  Created by Денис Васильевич on 18.11.2024.
//
//

import Foundation
import CoreData


extension CDCar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCar> {
        return NSFetchRequest<CDCar>(entityName: "CDCar")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var year: Int16
    @NSManaged public var price: Double
    @NSManaged public var imageData: Data?
    @NSManaged public var isAvailable: Bool

}

extension CDCar : Identifiable {

}
