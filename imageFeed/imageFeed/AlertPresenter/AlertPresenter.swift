import UIKit
extension UIViewController {
    func presentAlertOnTopViewController(message: String) {
        DispatchQueue.main.async { // Убедитесь, что это выполняется на главном потоке
            if let topViewController = self.getTopViewController() {
                let alert = UIAlertController(title: "Что-то пошло не так(", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default))
                topViewController.present(alert, animated: true)
            } else {
                print("Не найден контроллер для показа алерта.")
            }
        }
    }
    
       private func getTopViewController() -> UIViewController? {
                // Получаем активное ключевое окно из первой доступной UIWindowScene
                let currentWindow = UIApplication.shared
                    .connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first(where: { $0.isKeyWindow })

                // Начиная с корневого контроллера этого окна, идем вглубь по иерархии представлений
                var topController = currentWindow?.rootViewController
                while let presentedController = topController?.presentedViewController {
                    topController = presentedController
                }

                return topController
            }
    }

