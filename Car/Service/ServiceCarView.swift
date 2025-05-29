import SwiftUI

// Представление для отображения экрана сервиса автомобилей
struct ServiceCarView: View {
    // Состояние для управления отображением формы записи на сервис
    @State private var showingServiceForm = false
    // Состояние для управления отображением списка записей на сервис
    @State private var showingAppointments = false
    // ViewModel, который отвечает за логику управления записями на сервис
    @ObservedObject var viewModel = ServiceViewModel()
    // Состояние, указывающее, вошел ли пользователь в систему
    var isLoggedIn: Bool

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    // Кнопка для отображения формы записи на сервис
                    Button(action: {
                        showingServiceForm = true
                    }) {
                        Text("Schedule Service")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    // Кнопка для отображения списка записей на сервис
                    Button(action: {
                        showingAppointments = true
                    }) {
                        Text("View Appointments")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    // Кнопка для отображения формы записи на сервис (если пользователь не вошел в систему)
                    Button(action: {
                        showingServiceForm = true
                    }) {
                        Text("Schedule Service")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Service Car") // Устанавливает заголовок навигационной панели
            .sheet(isPresented: $showingServiceForm) {
                // Отображение формы записи на сервис
                ServiceFormView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingAppointments) {
                // Отображение списка записей на сервис
                ServiceAppointmentsView(viewModel: viewModel)
            }
        }
    }
}
