import UIKit

extension UIViewController {
    // 알림창 띄우기
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    // ViewController 전환
    func presentViewController<T: UIViewController>(from sourceVC: UIViewController, identifier: String, as type: T.Type) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            viewController.modalPresentationStyle = .fullScreen
            sourceVC.present(viewController, animated: true, completion: nil)
        }
    }
    
    // 바 버튼 생성
    func makeBarButton(title: String, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23)
        button.addTarget(self, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}

import Foundation

class Utils {
    // 현재 로그인된 아이디
    static func getUserId() -> String {
        return UserDefaults.standard.string(forKey: "loggedInUser")!
    }
    
    // todo키 받기
    static func getTodoKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return "\(getUserId())_\(dateString)_todo_data"
    }
}
