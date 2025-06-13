import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let id = idTextField.text, !id.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "아이디와 비밀번호를 모두 입력하세요.")
            return
        }
            
        let users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] ?? [:]
        
        if let savedPassword = users[id], savedPassword == password {
            // 로그인 성공 - 현재 로그인한 사용자 저장
            UserDefaults.standard.set(id, forKey: "loggedInUser")
            
            // 로그인 성공 - 홈 화면으로 이동
            presentViewController(from: self, identifier: "TabBarController", as: UITabBarController.self)

            } else {
                showAlert(message: "아이디 또는 비밀번호가 틀립니다.")
            }
        }
    
    // 회원가입 버튼
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        presentViewController(from:self, identifier: "SignupViewController", as: SignupViewController.self)
    }
}

