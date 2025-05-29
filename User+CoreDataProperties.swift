//
//  User+CoreDataProperties.swift
//  Car
//
//  Created by Денис Васильевич on 18.11.2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var username: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}
