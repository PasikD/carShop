import CoreData

// Структура для управления CoreData
struct PersistenceController {
    // Singleton-инстанс для доступа к PersistenceController
    static let shared = PersistenceController()

    // Превью-инстанс для предварительного просмотра данных
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Создание предварительных данных для превью
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            // Обработка ошибок при сохранении контекста
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // Контейнер для хранения данных
    let container: NSPersistentContainer

    // Инициализатор для создания контейнера
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Car")
        if inMemory {
            // Настройка контейнера для работы в памяти
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Обработка ошибок при загрузке хранилища данных
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // Автоматическое объединение изменений из родительского контекста
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
