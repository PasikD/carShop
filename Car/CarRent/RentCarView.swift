import SwiftUI

// Представление для отображения списка автомобилей в аренду
struct RentCarView: View {
    // ViewModel, который отвечает за логику управления списком автомобилей в аренду
    @ObservedObject var viewModel = RentCarViewModel()
    // Состояние для управления отображением экрана добавления автомобиля
    @State private var showingAddCar = false
    // Состояние для хранения выбранного автомобиля
    @State private var selectedCar: CDRentCar? = nil
    // Состояние для хранения фильтра по марке автомобиля
    @State private var filterMake: String = ""
    // Состояние для хранения фильтра по модели автомобиля
    @State private var filterModel: String = ""
    // Временное состояние для хранения фильтра по марке автомобиля
    @State private var tempFilterMake: String = ""
    // Временное состояние для хранения фильтра по модели автомобиля
    @State private var tempFilterModel: String = ""
    // Состояние для управления отображением фильтров
    @State private var isFilterExpanded = false
    // Состояние для управления отображением алерта
    @State private var showingAlert = false
    // Состояние для хранения ширины окна фильтров
    @State private var filterWindowWidth: CGFloat = 346
    // Состояние для хранения высоты окна фильтров
    @State private var filterWindowHeight: CGFloat = 232
    // Состояние для хранения отступа между элементами фильтров
    @State private var filterSpacing: CGFloat = 10
    // Состояние, указывающее, вошел ли пользователь в систему
    var isLoggedIn: Bool

    // Вычисляемое свойство для фильтрации автомобилей
    var filteredCars: [CDRentCar] {
        return viewModel.rentCars.filter { car in
            (filterMake.isEmpty || car.make?.lowercased().contains(filterMake.lowercased()) ?? false) &&
            (filterModel.isEmpty || car.model?.lowercased().contains(filterModel.lowercased()) ?? false)
        }
    }

    // Функция для отображения изображения автомобиля
    func carImage(car: CDRentCar, size: CGFloat) -> some View {
        if let imageData = car.imageData, let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            return Image(systemName: "car")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }

    // Функция для обновления размера окна фильтров
    func updateFilterWindowSize(width: CGFloat, height: CGFloat) {
        filterWindowWidth = width
        filterWindowHeight = height
    }

    // Функция для обновления отступа между элементами фильтров
    func updateFilterSpacing(spacing: CGFloat) {
        filterSpacing = spacing
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(filteredCars) { car in
                            if isLoggedIn {
                                HStack {
                                    // Ссылка для редактирования автомобиля
                                    NavigationLink(destination: EditRentCarView(car: Binding.constant(car), viewModel: viewModel)) {
                                        HStack {
                                            carImage(car: car, size: 100)
                                            VStack(alignment: .leading) {
                                                Text(car.make ?? "")
                                                    .font(.headline)
                                                Text(car.model ?? "")
                                                    .font(.subheadline)
                                                Text("Year: \(car.year)")
                                                    .font(.subheadline)
                                                Text("Price per day: $\(car.pricePerDay, specifier: "%.2f")")
                                                    .font(.subheadline)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            } else {
                                // Кнопка для отображения алерта при попытке аренды
                                Button(action: {
                                    showingAlert = true
                                }) {
                                    HStack {
                                        carImage(car: car, size: 100)
                                        VStack(alignment: .leading) {
                                            Text(car.make ?? "")
                                                .font(.headline)
                                            Text(car.model ?? "")
                                                .font(.subheadline)
                                            Text("Year: \(car.year)")
                                                .font(.subheadline)
                                            Text("Price per day: $\(car.pricePerDay, specifier: "%.2f")")
                                                .font(.subheadline)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Rent Cars") // Устанавливает заголовок навигационной панели
                .padding(.leading, -5)
                .navigationBarItems(trailing: isLoggedIn ? Button(action: {
                    showingAddCar = true
                }) {
                    Image(systemName: "plus")
                } : nil)
                .sheet(isPresented: $showingAddCar) {
                    // Отображение экрана добавления автомобиля в аренду
                    AddRentCarView(viewModel: viewModel)
                }
                .alert(isPresented: $showingAlert) {
                    // Отображение алерта для аренды автомобиля
                    Alert(
                        title: Text("Contact Us"),
                        message: Text("Для аренды звоните по номеру\n+7 999 999 99 99"),
                        dismissButton: .default(Text("OK"))
                    )
                }

                if isFilterExpanded {
                    VStack(spacing: 17) {
                        HStack {
                            Text("Filters")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isFilterExpanded = false
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 32)

                        TextField("Make", text: $tempFilterMake)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 282, height: 37)

                        TextField("Model", text: $tempFilterModel)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 282, height: 37)

                        Button(action: {
                            filterMake = tempFilterMake
                            filterModel = tempFilterModel
                            withAnimation {
                                isFilterExpanded = false
                            }
                        }) {
                            Text("Apply")
                                .font(.headline)
                                .frame(width: 110, height: 44)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical, 15)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(width: filterWindowWidth, height: filterWindowHeight)
                    .padding()
                    .padding(.top, -330)
                    .offset(x: -2, y: 0)
                    .transition(.move(edge: .top))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isFilterExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text("Filters")
                                .font(.headline)
                            Image(systemName: "line.horizontal.3.decrease.circle")
                        }
                    }
                }
            }
        }
    }
}
