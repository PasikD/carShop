import SwiftUI
import UIKit

// Структура для представления выбора изображения
struct ImagePicker: UIViewControllerRepresentable {
    // Привязка к выбранному изображению
    @Binding var image: UIImage?

    // Координатор для управления делегатами UIImagePickerController
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // Привязка к выбранному изображению
        @Binding var image: UIImage?

        // Инициализатор координатора
        init(image: Binding<UIImage?>) {
            _image = image
        }

        // Метод делегата, вызываемый при выборе изображения
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }
            picker.dismiss(animated: true)
        }

        // Метод делегата, вызываемый при отмене выбора изображения
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    // Метод для создания координатора
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image)
    }

    // Метод для создания UIViewController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    // Метод для обновления UIViewController
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
