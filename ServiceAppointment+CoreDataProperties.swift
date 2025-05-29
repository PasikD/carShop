//
//  ServiceAppointment+CoreDataProperties.swift
//  Car
//
//  Created by Денис Васильевич on 18.11.2024.
//
//

import Foundation
import CoreData


extension ServiceAppointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceAppointment> {
        return NSFetchRequest<ServiceAppointment>(entityName: "ServiceAppointment")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var date: Date?

}

extension ServiceAppointment : Identifiable {

}
