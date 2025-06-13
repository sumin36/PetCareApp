import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    var userId: String = Utils.getUserId()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.autocorrectionType = .no
        nameTextField.spellCheckingType = .no
            
        breedTextField.autocorrectionType = .no
        breedTextField.spellCheckingType = .no
        
        loadProfile()
    }
    
    // 사진 변경 버튼
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // 기본 이미지 버튼
    @IBAction func resetToDefaultImageButtonTapped(_ sender: UIButton) {
        let defaultImage = UIImage(named: "defaultProfile")
        profileImageView.image = defaultImage

        if let data = defaultImage?.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "\(userId)_profileImage")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            profileImageView.image = selectedImage
            if let data = selectedImage.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(data, forKey: "\(userId)_profileImage")
                    }
                }
        dismiss(animated: true)
    }
    
    // 저장 버튼
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        let name = nameTextField.text ?? ""
        let age = ageTextField.text ?? ""
        let breed = breedTextField.text ?? ""
        let genderIndex = genderSegmentedControl.selectedSegmentIndex
        let gender = genderSegmentedControl.titleForSegment(at: genderIndex) ?? ""

        UserDefaults.standard.set(name, forKey: "\(userId)_name")
        UserDefaults.standard.set(age, forKey: "\(userId)_age")
        UserDefaults.standard.set(breed, forKey: "\(userId)_breed")
        UserDefaults.standard.set(gender, forKey: "\(userId)_gender")
        showAlert(message: "프로필이 저장되었습니다!")
    }
    
    // 저장된 데이터 불러오기
    func loadProfile() {
        nameTextField.text = UserDefaults.standard.string(forKey: "\(userId)_name")
        ageTextField.text = UserDefaults.standard.string(forKey: "\(userId)_age")
        breedTextField.text = UserDefaults.standard.string(forKey: "\(userId)_breed")

        if let gender = UserDefaults.standard.string(forKey: "\(userId)_gender") {
            for index in 0..<genderSegmentedControl.numberOfSegments {
                if genderSegmentedControl.titleForSegment(at: index) == gender {
                    genderSegmentedControl.selectedSegmentIndex = index
                    break
                }
            }
        }

        if let imageData = UserDefaults.standard.data(forKey: "\(userId)_profileImage"),
           let image = UIImage(data: imageData) {
            profileImageView.image = image
        } else {
            // 이미지 없으면 기본 이미지로 설정
            profileImageView.image = UIImage(named: "defaultProfile")
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
