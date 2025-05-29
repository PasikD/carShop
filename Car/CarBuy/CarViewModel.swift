import Foundation
import CoreData

// ViewModel для управления данными автомобилей
class CarViewModel: ObservableObject {
    // Контекст CoreData для выполнения операций с базой данных
    private var context = CoreDataManager.shared.context
    // Опубликованное свойство для хранения списка автомобилей
    @Published var cars: [CDCar] = []

    // Инициализатор, который загружает автомобили при создании ViewModel
    init() {
        fetchCars()
    }

    // Метод для загрузки автомобилей из базы данных
    func fetchCars() {
        let request: NSFetchRequest<CDCar> = CDCar.fetchRequest()
        do {
            cars = try context.fetch(request)
        } catch {
            print("Error fetching cars: \(error)")
        }
    }

    // Метод для добавления нового автомобиля
    func addCar(make: String, model: String, year: Int, price: Double, isAvailable: Bool, imageData: Data?) {
        let car = CDCar(context: context)
        car.id = UUID()
        car.make = make
        car.model = model
        car.year = Int16(year)
        car.price = price
        car.isAvailable = isAvailable
        car.imageData = imageData

        saveContext()
        fetchCars()
    }

    // Метод для обновления существующего автомобиля
    func updateCar(car: CDCar, make: String, model: String, year: Int, price: Double, isAvailable: Bool, imageData: Data?) {
        car.make = make
        car.model = model
        car.year = Int16(year)
        car.price = price
        car.isAvailable = isAvailable
        car.imageData = imageData

        saveContext()
        fetchCars()
    }

    // Метод для удаления автомобиля
    func deleteCar(car: CDCar) {
        context.delete(car)
        saveContext()
        fetchCars()
    }

    // Метод для сохранения контекста CoreData
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
}
