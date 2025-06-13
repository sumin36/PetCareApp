import UIKit

protocol AddWalkDelegate: AnyObject {
    func didSaveWalk(_ walk: WalkRecord)
    func didEditWalk(_ walk: WalkRecord, at index: Int)
}


class AddWalkViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var weatherPickerView: UIPickerView!
    
    let weatherOptions = ["맑음", "조금흐림", "흐림", "비", "눈", "바람"]
    
    var existingRecord: WalkRecord?
    var existingIndex: Int?
    
    weak var delegate: AddWalkDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "산책 기록 추가"
        navigationItem.rightBarButtonItem = makeBarButton(title: "저장", action: #selector(saveWalk))
        navigationItem.leftBarButtonItem = makeBarButton(title: "취소", action: #selector(cancelTapped))
        
        datePicker.preferredDatePickerStyle = .wheels
        weatherPickerView.dataSource = self
        weatherPickerView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
        
        weatherPickerView.selectRow(2, inComponent: 0, animated: false)
        
        // 수정 모드인 경우
        if let record = existingRecord {
            datePicker.date = record.date
            locationTextField.text = record.location
            timeTextField.text = "\(record.duration)"
            if let index = weatherOptions.firstIndex(of: record.weather) {
                weatherPickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    // 기록 저장 버튼
    @objc func saveWalk() {
        guard let duration = timeTextField.text, !duration.isEmpty,
              let location = locationTextField.text, !location.isEmpty else {
            showAlert(message: "산책 시간과 장소를 입력해주세요.")
            return
        }

        let selectedWeather = weatherOptions[weatherPickerView.selectedRow(inComponent: 0)]
        let newWalk = WalkRecord(date: datePicker.date, duration: duration, location: location, weather: selectedWeather)
        
        if let index = existingIndex {
            delegate?.didEditWalk(newWalk, at: index)
        } else {
            delegate?.didSaveWalk(newWalk)
        }
        
        dismiss(animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        weatherOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        weatherOptions[row]
    }
    
}
