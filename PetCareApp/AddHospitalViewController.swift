import UIKit

protocol AddHospitalDelegate: AnyObject {
    func didSaveHospital(_ walk: HospitalRecord)
    func didEditHospital(_ walk: HospitalRecord, at index: Int)
}

class AddHospitalViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hospitalTextField: UITextField!
    @IBOutlet weak var vaccinationSwitch: UISwitch!
    @IBOutlet weak var memoTextView: UITextView!
    
    var existingRecord: HospitalRecord?
    var existingIndex: Int?
    
    weak var delegate: AddHospitalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "병원 기록 추가"
        navigationItem.rightBarButtonItem = makeBarButton(title: "저장", action: #selector(saveHospital))
        navigationItem.leftBarButtonItem = makeBarButton(title: "취소", action: #selector(cancelTapped))
        
        datePicker.preferredDatePickerStyle = .wheels
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
        
        // 수정 모드인 경우
        if let record = existingRecord {
            datePicker.date = record.date
            hospitalTextField.text = record.hospitalName
            vaccinationSwitch.isOn = record.vaccination
            memoTextView.text = record.memo
        }
        
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.black.cgColor
        memoTextView.layer.cornerRadius = 8
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
        
    }
    
    @objc func saveHospital() {
        guard let hospitalName = hospitalTextField.text, !hospitalName.isEmpty else {
            showAlert(message: "병원 이름을 입력해주세요.")
            return
        }
        let memo = memoTextView.text ?? ""
        let vaccinated = vaccinationSwitch.isOn
        let newHospital = HospitalRecord(date: datePicker.date, hospitalName: hospitalName, vaccination: vaccinated, memo: memo)
        
        if let index = existingIndex {
            delegate?.didEditHospital(newHospital, at: index)
        } else {
            delegate?.didSaveHospital(newHospital)
        }
        dismiss(animated: true)
    }
}
