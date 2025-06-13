import UIKit

class HospitalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var hospitalRecords: [HospitalRecord] = []
            
    let userId = Utils.getUserId()
    
    var hospitalRecordKey: String {
        return "\(userId)_hospitalRecords"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadRecords()
    }
    
    // 기록 추가 버튼
    @IBAction func addHospitalTapped(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddHospitalViewController") as? AddHospitalViewController {
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        }
    }
    
    func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: hospitalRecordKey),
           let saved = try? JSONDecoder().decode([HospitalRecord].self, from: data) {
            hospitalRecords = saved
        } else {
            hospitalRecords = []
        }
        hospitalRecords.sort { $0.date > $1.date }
        tableView.reloadData()
    }
    
    func saveRecords() {
        if let data = try? JSONEncoder().encode(hospitalRecords) {
            UserDefaults.standard.set(data, forKey: hospitalRecordKey)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hospitalRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = hospitalRecords[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell", for: indexPath)
            
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        cell.textLabel?.text = "\(formatter.string(from: record.date)) • \(record.hospitalName)"
        let vaccinationText = record.vaccination ? "예방접종 O" : "예방접종 X"
        cell.detailTextLabel?.text = "\(vaccinationText) • \(record.memo)"
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 기록 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            hospitalRecords.remove(at: indexPath.row)
            saveRecords()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    // 수정 기능
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recordToEdit = hospitalRecords[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddHospitalViewController") as? AddHospitalViewController {
            vc.existingRecord = recordToEdit
            vc.existingIndex = indexPath.row
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        }
    }
}

extension HospitalViewController: AddHospitalDelegate {
    func didSaveHospital(_ hospital: HospitalRecord) {
        hospitalRecords.append(hospital)
        saveRecords()
        tableView.reloadData()
    }
    
    func didEditHospital(_ walk: HospitalRecord, at index: Int) {
        hospitalRecords[index] = walk
        saveRecords()
        tableView.reloadData()
    }
}
