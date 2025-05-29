import SwiftUI

// Представление для добавления нового автомобиля в аренду
struct AddRentCarView: View {
    // Свойство для управления представлением (например, закрытие экрана)
    @Environment(\.presentationMode) var presentationMode
    // ViewModel, который отвечает за логику добавления автомобиля в аренду
    @ObservedObject var viewModel: RentCarViewModel
    // Состояние для хранения марки автомобиля
    @State private var make: String = ""
    // Состояние для хранения модели автомобиля
    @State private var model: String = ""
    // Состояние для хранения года выпуска автомобиля
    @State private var year: Int = 0
    // Состояние для хранения цены аренды автомобиля за день
    @State private var pricePerDay: Double = 0.0
    // Состояние для хранения доступности автомобиля
    @State private var isAvailable: Bool = true
    // Состояние для хранения данных изображения автомобиля
    @State private var imageData: Data? = nil
    // Состояние для управления отображением ImagePicker
    @State private var showingImagePicker = false
    // Состояние для хранения выбранного изображения
    @State private var image: UIImage?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Car")) {
                    // Поле для ввода марки автомобиля
                    TextField("Make", text: $make)
                    // Поле для ввода модели автомобиля
                    TextField("Model", text: $model)
                    // Поле для ввода года выпуска автомобиля
                    TextField("Year", value: $year, formatter: NumberFormatter())
                    // Поле для ввода цены аренды автомобиля за день
                    TextField("Price per day", value: $pricePerDay, formatter: NumberFormatter())
                    // Переключатель для указания доступности автомобиля
                    Toggle("Available", isOn: $isAvailable)
                    // Отображение выбранного изображения или кнопки для выбора изображения
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Text("Select Image")
                        }
                    }
                }
                // Кнопка для добавления автомобиля в аренду
                Button(action: {
                    viewModel.addRentCar(make: make, model: model, year: year, pricePerDay: pricePerDay, isAvailable: isAvailable, imageData: imageData)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add")
                }
            }
            .navigationBarTitle("Add Rent Car") // Устанавливает заголовок навигационной панели
        }
        .sheet(isPresented: $showingImagePicker) {
            // Отображение ImagePicker для выбора изображения
            ImagePicker(image: $image)
        }
        .onChange(of: image) { oldValue, newValue in
            // Обновление данных изображения при выборе нового изображения
            if let data = newValue?.jpegData(compressionQuality: 0.8) {
                imageData = data
            }
        }
    }
}
