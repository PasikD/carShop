import SwiftUI

// Представление для отображения формы записи на сервис
struct ServiceFormView: View {
    // Свойство для управления представлением (например, закрытие экрана)
    @Environment(\.presentationMode) var presentationMode
    // ViewModel, который отвечает за логику управления записями на сервис
    @ObservedObject var viewModel: ServiceViewModel
    // Состояние для хранения имени клиента
    @State private var name: String = ""
    // Состояние для хранения телефона клиента
    @State private var phone: String = ""
    // Состояние для хранения марки автомобиля
    @State private var make: String = ""
    // Состояние для хранения модели автомобиля
    @State private var model: String = ""
    // Состояние для хранения выбранной даты
    @State private var selectedDate: Date = Date()
    // Состояние для хранения выбранного временного слота
    @State private var selectedTimeSlot: Date? = nil
    // Состояние для управления отображением алерта
    @State private var showAlert: Bool = false

    // Функция для генерации временных слотов для выбранной даты
    func generateTimeSlots(for date: Date) -> [Date] {
        let calendar = Calendar.current
        var timeSlots: [Date] = []

        var startTime = calendar.startOfDay(for: date)
        if let hour = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: startTime) {
            startTime = hour
        }

        while startTime <= calendar.date(bySettingHour: 20, minute: 0, second: 0, of: startTime)! {
            timeSlots.append(startTime)
            if let nextTime = calendar.date(byAdding: .minute, value: 30, to: startTime) {
                startTime = nextTime
            }
        }

        return timeSlots
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    // Поле для ввода имени клиента
                    TextField("Name", text: $name)
                    // Поле для ввода телефона клиента
                    TextField("Phone", text: $phone)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Car Information")) {
                    // Поле для ввода марки автомобиля
                    TextField("Make", text: $make)
                    // Поле для ввода модели автомобиля
                    TextField("Model", text: $model)
                }

                Section(header: Text("Service Date")) {
                    // Выбор даты сервиса
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                }

                Section(header: Text("Service Time")) {
                    // Выбор времени сервиса
                    Picker("Time", selection: $selectedTimeSlot) {
                        ForEach(generateTimeSlots(for: selectedDate), id: \.self) { timeSlot in
                            Text(timeSlot, style: .time).tag(timeSlot)
                        }
                    }
                }

                // Кнопка для отправки формы
                Button(action: {
                    if let selectedTimeSlot = selectedTimeSlot {
                        let appointmentDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: selectedTimeSlot), minute: Calendar.current.component(.minute, from: selectedTimeSlot), second: 0, of: selectedDate)!
                        viewModel.addAppointment(name: name, phone: phone, make: make, model: model, date: appointmentDate)
                        showAlert = true
                    }
                }) {
                    Text("Submit")
                }
            }
            .navigationBarTitle("Service Form") // Устанавливает заголовок навигационной панели
            .alert(isPresented: $showAlert) {
                // Отображение алерта при успешной записи на сервис
                Alert(
                    title: Text("Success"),
                    message: Text("Your service appointment has been successfully scheduled."),
                    dismissButton: .default(Text("OK"), action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                )
            }
        }
    }
}
