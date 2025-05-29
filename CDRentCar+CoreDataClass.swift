import Foundation
import CoreData

@objc(CDRentCar)
public class CDRentCar: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var year: Int16
    @NSManaged public var pricePerDay: Double
    @NSManaged public var isAvailable: Bool
    @NSManaged public var imageData: Data?
}

extension CDRentCar {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRentCar> {
        return NSFetchRequest<CDRentCar>(entityName: "CDRentCar")
    }
}
