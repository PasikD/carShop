import Foundation
import CoreData

// ViewModel для управления данными записей на сервис
class ServiceViewModel: ObservableObject {
    // Опубликованное свойство для хранения списка записей на сервис
    @Published var appointments: [ServiceAppointment] = []

    // Контекст CoreData для выполнения операций с базой данных
    private var context = CoreDataManager.shared.context

    // Инициализатор, который загружает записи на сервис при создании ViewModel
    init() {
        fetchAppointments()
    }

    // Метод для загрузки записей на сервис из базы данных
    func fetchAppointments() {
        let request: NSFetchRequest<ServiceAppointment> = ServiceAppointment.fetchRequest()
        do {
            appointments = try context.fetch(request)
        } catch {
            print("Error fetching appointments: \(error)")
        }
    }

    // Метод для добавления новой записи на сервис
    func addAppointment(name: String, phone: String, make: String, model: String, date: Date) {
        let appointment = ServiceAppointment(context: context)
        appointment.id = UUID()
        appointment.name = name
        appointment.phone = phone
        appointment.make = make
        appointment.model = model
        appointment.date = date

        saveContext()
        fetchAppointments()
    }

    // Метод для удаления записи на сервис
    func deleteAppointment(appointment: ServiceAppointment) {
        context.delete(appointment)
        saveContext()
        fetchAppointments()
    }

    // Метод для сохранения контекста CoreData
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
}
