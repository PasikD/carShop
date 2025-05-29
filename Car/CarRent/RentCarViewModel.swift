import Foundation
import CoreData

// ViewModel для управления данными автомобилей в аренду
class RentCarViewModel: ObservableObject {
    // Контекст CoreData для выполнения операций с базой данных
    private var context = CoreDataManager.shared.context
    // Опубликованное свойство для хранения списка автомобилей в аренду
    @Published var rentCars: [CDRentCar] = []

    // Инициализатор, который загружает автомобили в аренду при создании ViewModel
    init() {
        fetchRentCars()
    }

    // Метод для загрузки автомобилей в аренду из базы данных
    func fetchRentCars() {
        let request: NSFetchRequest<CDRentCar> = CDRentCar.fetchRequest()
        do {
            rentCars = try context.fetch(request)
        } catch {
            print("Error fetching rent cars: \(error)")
        }
    }

    // Метод для добавления нового автомобиля в аренду
    func addRentCar(make: String, model: String, year: Int, pricePerDay: Double, isAvailable: Bool, imageData: Data?) {
        let rentCar = CDRentCar(context: context)
        rentCar.id = UUID()
        rentCar.make = make
        rentCar.model = model
        rentCar.year = Int16(year)
        rentCar.pricePerDay = pricePerDay
        rentCar.isAvailable = isAvailable
        rentCar.imageData = imageData

        saveContext()
        fetchRentCars()
    }

    // Метод для обновления существующего автомобиля в аренду
    func updateRentCar(rentCar: CDRentCar, make: String, model: String, year: Int, pricePerDay: Double, isAvailable: Bool, imageData: Data?) {
        rentCar.make = make
        rentCar.model = model
        rentCar.year = Int16(year)
        rentCar.pricePerDay = pricePerDay
        rentCar.isAvailable = isAvailable
        rentCar.imageData = imageData

        saveContext()
        fetchRentCars()
    }

    // Метод для удаления автомобиля в аренду
    func deleteRentCar(rentCar: CDRentCar) {
        context.delete(rentCar)
        saveContext()
        fetchRentCars()
    }

    // Метод для сохранения контекста CoreData
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
}
