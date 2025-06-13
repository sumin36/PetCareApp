import UIKit

class WalkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var walkRecords: [WalkRecord] = []
        
    let userId = Utils.getUserId()
    
    var walkRecordKey: String {
        return "\(userId)_walkRecords"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadRecords()
    }
    
    // 기록 추가 버튼
    @IBAction func addWalkTapped(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddWalkViewController") as? AddWalkViewController {
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        }
    }
    
    func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: walkRecordKey),
           let saved = try? JSONDecoder().decode([WalkRecord].self, from: data) {
            walkRecords = saved
        } else {
            walkRecords = []
        }
        
        walkRecords.sort { $0.date > $1.date }
        tableView.reloadData()
    }

    
    func saveRecords() {
        if let data = try? JSONEncoder().encode(walkRecords) {
            UserDefaults.standard.set(data, forKey: walkRecordKey)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            walkRecords.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = walkRecords[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalkCell", for: indexPath)
            
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        cell.textLabel?.text = "\(formatter.string(from: record.date)) • \(record.location)"
        cell.detailTextLabel?.text = "\(record.duration)분 • \(record.weather)"
        
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

    // 삭제 기능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            walkRecords.remove(at: indexPath.row)
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
        
        let recordToEdit = walkRecords[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddWalkViewController") as? AddWalkViewController {
            vc.existingRecord = recordToEdit
            vc.existingIndex = indexPath.row
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        }
    }
}

extension WalkViewController: AddWalkDelegate {
    func didSaveWalk(_ walk: WalkRecord) {
        walkRecords.append(walk)
        saveRecords()
        tableView.reloadData()
    }
    
    func didEditWalk(_ walk: WalkRecord, at index: Int) {
        walkRecords[index] = walk
        saveRecords()
        tableView.reloadData()
    }
}
