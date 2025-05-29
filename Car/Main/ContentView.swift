import SwiftUI

// Основное представление приложения
struct ContentView: View {
    // ViewModel для управления состоянием пользователя
    @ObservedObject var userViewModel = UserViewModel()

    var body: some View {
        ZStack {
            // Вкладки для навигации между различными представлениями
            TabView {
                // Вкладка для представления аккаунта
                AccountView(viewModel: userViewModel)
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Account")
                    }

                // Вкладка для представления списка автомобилей на продажу
                CarListView(isLoggedIn: userViewModel.isLoggedIn)
                    .tabItem {
                        Image(systemName: "car")
                        Text("Buy Car")
                    }

                // Вкладка для представления списка автомобилей в аренду
                RentCarView(isLoggedIn: userViewModel.isLoggedIn)
                    .tabItem {
                        Image(systemName: "car.circle")
                        Text("Rent Car")
                    }

                // Вкладка для представления сервиса автомобилей
                ServiceCarView(isLoggedIn: userViewModel.isLoggedIn)
                    .tabItem {
                        Image(systemName: "wrench.and.screwdriver")
                        Text("Service Car")
                    }
            }

            // Вертикальный стек для отображения разделителя внизу экрана
            VStack {
                Spacer()

                // Разделитель
                Divider()
                    .background(Color.black)
                    .frame(height: 2)
                    .padding(.vertical)
                    .padding(.horizontal)

                Spacer().frame(height: 33)
            }
        }
    }
}

// Предварительный просмотр представления
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
