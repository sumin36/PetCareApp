import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        passwordCheckTextField.isSecureTextEntry = true
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        
        let id = idTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordCheck = passwordCheckTextField.text ?? ""

        // null값 확인
        if id.isEmpty || password.isEmpty || passwordCheck.isEmpty {
            showAlert(message: "모든 필드를 입력해주세요.")
            return
        }
        
        // 비밀번호 확인
        if password != passwordCheck {
            showAlert(message: "비밀번호가 일치하지 않습니다.")
            return
        }
        
        var users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] ?? [:]

            if users[id] != nil {
                showAlert(message: "이미 사용중인 아이디입니다.")
                return
            }

            // 회원가입 정보 저장
            users[id] = password
            UserDefaults.standard.set(users, forKey: "users")

            showAlert(message: "회원가입 완료!") {
                // 로그인 화면으로 이동
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    // 로그인 버튼
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        presentViewController(from: self, identifier: "LoginViewController", as: LoginViewController.self)
    }
}
