import SwiftUI

// Представление для редактирования информации об автомобиле в аренду
struct EditRentCarView: View {
    // ViewModel, который отвечает за логику управления данными автомобилей в аренду
    @ObservedObject var viewModel: RentCarViewModel
    // Состояние для хранения марки автомобиля
    @State private var make: String
    // Состояние для хранения модели автомобиля
    @State private var model: String
    // Состояние для хранения года выпуска автомобиля
    @State private var year: String
    // Состояние для хранения цены аренды автомобиля за день
    @State private var pricePerDay: String
    // Состояние для хранения данных изображения автомобиля
    @State private var imageData: Data?
    // Состояние для управления отображением ImagePicker
    @State private var showingImagePicker = false
    // Состояние для хранения выбранного изображения
    @State private var image: UIImage?
    // Свойство для управления представлением (например, закрытие экрана)
    @Environment(\.presentationMode) var presentationMode
    // Привязка к выбранному автомобилю в аренду
    @Binding var car: CDRentCar?

    // Инициализатор, который устанавливает начальные значения состояний на основе выбранного автомобиля
    init(car: Binding<CDRentCar?>, viewModel: RentCarViewModel) {
        self._car = car
        self.viewModel = viewModel
        if let car = car.wrappedValue {
            _make = State(initialValue: car.make ?? "")
            _model = State(initialValue: car.model ?? "")
            _year = State(initialValue: String(car.year))
            _pricePerDay = State(initialValue: String(format: "%.2f", car.pricePerDay))
            _imageData = State(initialValue: car.imageData)
        } else {
            _make = State(initialValue: "")
            _model = State(initialValue: "")
            _year = State(initialValue: "")
            _pricePerDay = State(initialValue: "")
            _imageData = State(initialValue: nil)
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Car Details")) {
                // Поле для ввода марки автомобиля
                TextField("Make", text: $make)
                // Поле для ввода модели автомобиля
                TextField("Model", text: $model)
                // Поле для ввода года выпуска автомобиля
                TextField("Year", text: $year)
                    .keyboardType(.numberPad)
                // Поле для ввода цены аренды автомобиля за день
                TextField("Price per Day", text: $pricePerDay)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("Car Image")) {
                // Отображение выбранного изображения или изображения по умолчанию
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } else {
                    Image(systemName: "car")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                // Кнопка для выбора изображения
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("Select Image")
                }
            }

            Section {
                // Кнопка для сохранения изменений
                Button(action: {
                    if let yearInt = Int(year), let pricePerDayDouble = Double(pricePerDay), let car = car {
                        viewModel.updateRentCar(rentCar: car, make: make, model: model, year: yearInt, pricePerDay: pricePerDayDouble, isAvailable: true, imageData: imageData)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Save")
                }

                // Кнопка для удаления автомобиля
                Button(action: {
                    if let car = car {
                        viewModel.deleteRentCar(rentCar: car)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Delete")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitle("Edit Rent Car") // Устанавливает заголовок навигационной панели
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
