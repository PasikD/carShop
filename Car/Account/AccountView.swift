import SwiftUI

// Представление для экрана аутентификации пользователя
struct AccountView: View {
    // ViewModel, который отвечает за логику аутентификации
    @ObservedObject var viewModel: UserViewModel
    // Состояние для хранения введенного пользователем имени
    @State private var username: String = ""
    // Состояние для хранения введенного пользователем пароля
    @State private var password: String = ""

    var body: some View {
        ZStack {
            VStack {
                // Пустое пространство высотой 170 пикселей для отступа сверху
                Spacer().frame(height: 170)

                // Проверка, вошел ли пользователь в систему
                if viewModel.isLoggedIn {
                    // Приветственное сообщение для администратора
                    Text("Welcome, Admin!")
                        .font(.system(size: 30))
                        .padding()

                    HStack {
                        Spacer()
                        // Кнопка выхода
                        Button(action: {
                            viewModel.logout()
                        }) {
                            Text("Logout")
                                .font(.system(size: 22))
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .padding()
                } else {
                    // Форма входа
                    VStack(spacing: 20) {
                        GeometryReader { geometry in
                            HStack {
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Login")
                                        .font(.system(size: 18))
                                        .padding(.bottom, -5)
                                        .fontWeight(.regular)

                                    // Поле для ввода имени пользователя
                                    TextField("", text: $username)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 0.3)
                                        )
                                        .frame(width: 346, height: 38)
                                }
                                Spacer()
                            }
                            .position(x: geometry.size.width / 2, y: 160) // Задаем абсолютные координаты
                        }

                        GeometryReader { geometry in
                            HStack {
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Password")
                                        .font(.system(size: 18))
                                        .padding(.bottom, -5)
                                        .fontWeight(.regular)

                                    // Поле для ввода пароля
                                    SecureField("", text: $password)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 0.3)
                                        )
                                        .frame(width: 346, height: 38)
                                }
                                Spacer()
                            }
                            .position(x: geometry.size.width / 2, y: 40) // Задаем абсолютные координаты
                        }

                        GeometryReader { geometry in
                            HStack {
                                Spacer()
                                // Кнопка для выполнения входа
                                Button(action: {
                                    viewModel.login(username: username, password: password)
                                }) {
                                    Text("Login")
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(13)
                                }
                                Spacer()
                            }
                            .position(x: geometry.size.width / 2, y: -50) // Задаем абсолютные координаты
                        }
                    }
                }
            }
            .navigationBarTitle("Account") // Устанавливает заголовок навигационной панели

            GeometryReader { geometry in
                // Текст, который отображается по центру экрана
                Text("Authorization\nfor Admin")
                    .font(.system(size: 37))
                    .frame(width: 259, height: 96)
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .position(x: geometry.size.width / 2, y: 210)
                    .offset(x: 0)
                    .fontWeight(.regular)
            }
        }
    }
}
