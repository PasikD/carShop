import SwiftUI

// Представление для отображения списка записей на сервис
struct ServiceAppointmentsView: View {
    // ViewModel, который отвечает за логику управления записями на сервис
    @ObservedObject var viewModel: ServiceViewModel

    var body: some View {
        NavigationView {
            // Список записей на сервис
            List(viewModel.appointments, id: \.id) { appointment in
                VStack(alignment: .leading) {
                    // Отображение имени клиента
                    Text(appointment.name ?? "")
                        .font(.headline)
                    // Отображение телефона клиента
                    Text(appointment.phone ?? "")
                        .font(.subheadline)
                    // Отображение марки и модели автомобиля
                    Text("\(appointment.make ?? "") \(appointment.model ?? "")")
                        .font(.subheadline)
                    // Отображение даты записи
                    Text(appointment.date ?? Date(), style: .date)
                        .font(.subheadline)
                    // Отображение времени записи
                    Text(appointment.date ?? Date(), style: .time)
                        .font(.subheadline)
                    // Кнопка для удаления записи
                    Button(action: {
                        print("Deleting appointment: \(appointment.id?.uuidString ?? "")")
                        viewModel.deleteAppointment(appointment: appointment)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Service Appointments") // Устанавливает заголовок навигационной панели
        }
    }
}
