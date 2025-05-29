//
//  CDRentCar+CoreDataProperties.swift
//  Car
//
//  Created by Денис Васильевич on 18.11.2024.
//
//

import Foundation
import CoreData


extension CDRentCar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRentCar> {
        return NSFetchRequest<CDRentCar>(entityName: "CDRentCar")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var year: Int16
    @NSManaged public var pricePerDay: Double
    @NSManaged public var isAvailable: Bool
    @NSManaged public var imageData: Data?

}

extension CDRentCar : Identifiable {

}
