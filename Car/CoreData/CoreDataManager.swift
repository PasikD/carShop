import CoreData

// Класс для управления CoreData
class CoreDataManager {
    // Singleton-инстанс для доступа к CoreDataManager
    static let shared = CoreDataManager()

    // Приватный инициализатор для предотвращения создания новых экземпляров
    private init() {}

    // Лениво инициализируемый контейнер для хранения данных
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Car")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Обработка ошибок при загрузке хранилища данных
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // Контекст для выполнения операций с базой данных
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Метод для сохранения контекста
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                // Обработка ошибок при сохранении контекста
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
