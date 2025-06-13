import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    
    @IBOutlet weak var todoTableView: UITableView!
    var todos: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        loadTodayTodos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfile()
        loadTodayTodos()
    }
    
    // 로그아웃 버튼
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        // 로그인 정보 삭제, 로그인 화면으로 이동
        UserDefaults.standard.removeObject(forKey: "loggedInUser")
        presentViewController(from: self, identifier: "LoginViewController", as: LoginViewController.self)
    }
    
    func loadProfile() {
        let userId = Utils.getUserId()
        
        let name = UserDefaults.standard.string(forKey: "\(userId)_name") ?? "-"
        let age = UserDefaults.standard.string(forKey: "\(userId)_age") ?? "-"
        let gender = UserDefaults.standard.string(forKey: "\(userId)_gender") ?? "-"
        let breed = UserDefaults.standard.string(forKey: "\(userId)_breed") ?? "-"
        
        nameLabel.text = "이름: \(name)"
        ageLabel.text = "나이: \(age)살"
        genderLabel.text = "성별: \(gender)"
        breedLabel.text = "품종: \(breed)"
        
        if let imageData = UserDefaults.standard.data(forKey: "\(userId)_profileImage"),
           let image = UIImage(data: imageData) {
            profileImageView.image = image
        } else {
            let defaultImage = UIImage(named: "defaultProfile")
            profileImageView.image = defaultImage // 기본 이미지
        }
    }
    
    func loadTodayTodos() {
        let today = Date()
        let key = Utils.getTodoKey(for: today)

        if let data = UserDefaults.standard.data(forKey: key),
           let items = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = items
        } else {
            todos = []
        }
        todoTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textAlignment = .center
        return cell
    }

    
}
