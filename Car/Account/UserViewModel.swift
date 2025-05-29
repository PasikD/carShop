import Foundation
import CoreData

// ViewModel для управления состоянием аутентификации пользователя
class UserViewModel: ObservableObject {
    // Состояние, указывающее, вошел ли пользователь в систему
    @Published var isLoggedIn: Bool = false
    // Состояние для хранения имени пользователя
    @Published var username: String = ""
    // Состояние для хранения пароля пользователя
    @Published var password: String = ""

    // Контекст CoreData для выполнения операций с базой данных
    private var context = CoreDataManager.shared.context

    // Метод для выполнения входа пользователя
    func login(username: String, password: String) {
        // Проверка на жестко закодированные учетные данные
        if username == "1234" && password == "4321" {
            self.isLoggedIn = true
            self.username = username
            self.password = password
            return
        }

        // Создание запроса для поиска пользователя в базе данных
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        do {
            // Выполнение запроса
            let results = try context.fetch(request)
            if let user = results.first {
                // Если пользователь найден, устанавливаем состояние входа
                self.isLoggedIn = true
                self.username = user.username ?? ""
                self.password = user.password ?? ""
            } else {
                // Если пользователь не найден, устанавливаем состояние выхода
                self.isLoggedIn = false
            }
        } catch {
            // Обработка ошибок при выполнении запроса
            print("Error fetching user: \(error)")
        }
    }

    // Метод для регистрации нового пользователя
    func register(username: String, password: String) {
        // Создание запроса для проверки существования пользователя
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)

        do {
            // Выполнение запроса
            let results = try context.fetch(request)
            if results.isEmpty {
                // Если пользователь не найден, создаем нового пользователя
                let newUser = User(context: context)
                newUser.id = UUID()
                newUser.username = username
                newUser.password = password
                saveContext()
                self.isLoggedIn = true
                self.username = username
                self.password = password
            } else {
                // Если пользователь уже существует, устанавливаем состояние выхода
                self.isLoggedIn = false
            }
        } catch {
            // Обработка ошибок при выполнении запроса
            print("Error registering user: \(error)")
        }
    }

    // Метод для выхода пользователя из системы
    func logout() {
        self.isLoggedIn = false
        self.username = ""
        self.password = ""
    }

    // Метод для сохранения контекста CoreData
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
