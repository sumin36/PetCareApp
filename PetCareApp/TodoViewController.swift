import UIKit

class TodoViewController: UIViewController {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currentDate = Date()
    var selectedDate = Date()
    var daysInMonth: [String] = []
    var todos: [TodoItem] = []
    
    var userId = Utils.getUserId()
    
    var isAddingTodo = false
    var editingIndex: Int? = nil
    var hasSelectedToday = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
            
        selectedDate = Date()
        setupCalendar()
        loadTodos()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissInput))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasSelectedToday {
            selectToday()
            hasSelectedToday = true
        }
    }
    
    @objc func dismissInput() {
        if isAddingTodo || editingIndex != nil {
            isAddingTodo = false
            editingIndex = nil
            tableView.reloadData()
            view.endEditing(true)
        }
    }
    
    // 달력 구성
    func setupCalendar() {
        daysInMonth = generateDaysForMonth(for: currentDate)
        monthLabel.text = formatMonthYear(date: currentDate)
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.selectToday()
        }
    }
    
    // 날짜 배열 생성
    func generateDaysForMonth(for date: Date) -> [String] {
        var days: [String] = []
            
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components) else { return [] }
        guard let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
            
        days += Array(repeating: "", count: firstWeekday - 1)
            
        // 날짜 추가
        for day in range {
            days.append("\(day)")
        }
        return days
    }

    func formatMonthYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월"
        return formatter.string(from: date)
    }
    
    // 오늘의 날짜로 표시
    func selectToday() {
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)

        if todayComponents.year == currentComponents.year && todayComponents.month == currentComponents.month {
            if let day = todayComponents.day {
                for (index, dayString) in daysInMonth.enumerated() {
                    if dayString == "\(day)" {
                        let indexPath = IndexPath(item: index, section: 0)
                        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
                        break
                    }
                }
            }
        }
    }

    // 선택한 날짜의 todo 리스트 불러오기
    func loadTodos() {
        let key = Utils.getTodoKey(for: selectedDate)
        if let data = UserDefaults.standard.data(forKey: key),
            let items = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = items
        } else {
            todos = []
        }
        tableView.reloadData()
    }

    // todo 저장
    func saveTodos() {
        let key = Utils.getTodoKey(for: selectedDate)
        if let data = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    // 이전 달로 이동
    @IBAction func previousMonth(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        setupCalendar()
    }
    
    // 다음 달로 이동
    @IBAction func nextMonth(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        setupCalendar()
    }
    
    // todo 추가 버튼
    @IBAction func addTodoButtonTapped(_ sender: UIButton) {
        guard !isAddingTodo else { return }

        isAddingTodo = true
        let inputIndexPath = IndexPath(row: todos.count, section: 0)
        tableView.insertRows(at: [inputIndexPath], with: .automatic)

        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: inputIndexPath) as? TodoInputCell {
                cell.todoTextField.becomeFirstResponder()
            }
        }
    }
}

extension TodoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }

    // 셀 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dayLabel.text = daysInMonth[indexPath.item]
        return cell
    }

    // 달력셀 선택시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = daysInMonth[indexPath.item]
        if selectedDay != "" {
            // selectedDate 갱신
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: currentDate)
            var dateComponents = DateComponents()
            dateComponents.year = components.year
            dateComponents.month = components.month
            dateComponents.day = Int(selectedDay)
            if let newDate = calendar.date(from: dateComponents) {
                selectedDate = newDate
            }
                
            selectedDateLabel.text = "\(selectedDay)일"
            loadTodos()
        }
    }

    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        let height = collectionView.frame.height / 6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count + (isAddingTodo ? 1 : 0)
    }

    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 추가 셀
        if isAddingTodo && indexPath.row == todos.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoInputCell", for: indexPath) as! TodoInputCell
            cell.todoTextField.delegate = self
            cell.todoTextField.text = ""
            return cell
        } else if let editingIndex = editingIndex, editingIndex == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoInputCell", for: indexPath) as! TodoInputCell
            cell.todoTextField.delegate = self
            cell.todoTextField.text = todos[indexPath.row].title

            DispatchQueue.main.async {
                cell.todoTextField.becomeFirstResponder()
                let endPosition = cell.todoTextField.endOfDocument
                cell.todoTextField.selectedTextRange = cell.todoTextField.textRange(from: endPosition, to: endPosition)
            }
            return cell
        } else {
            // 일반 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
            let todo = todos[indexPath.row]
            cell.todoLabel.text = todo.title
            cell.checkBoxImageView.image = todo.isDone ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")

            // 체크박스 이미지 눌렀을 때 토글 동작 콜백 설정
            cell.checkBoxTapped = {
                self.todos[indexPath.row].isDone.toggle()
                self.saveTodos()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
    }

    // todo셀 선택 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < todos.count {
            if editingIndex == indexPath.row {
                return
            }
            // 수정 모드 진입
            editingIndex = indexPath.row
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }


    // todo 삭제
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isAddingTodo && indexPath.row == todos.count {
                return
            }
            
            todos.remove(at: indexPath.row)
            saveTodos()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}

extension TodoViewController: UITextFieldDelegate {

    // todo 입력 후 엔터 누를시
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if let editingIndex = editingIndex {
            // 수정 모드 종료
            if !text.isEmpty {
                todos[editingIndex].title = text
                saveTodos()
            }
            self.editingIndex = nil
            tableView.reloadData()
            textField.resignFirstResponder()
            return true
        }

        // 빈 셀일 경우
        if text.isEmpty {
            isAddingTodo = false
            tableView.reloadData()
            textField.resignFirstResponder()
            return true
        }

        todos.append(TodoItem(title: text, isDone: false))
        saveTodos()
        isAddingTodo = false
        tableView.reloadData()
        textField.resignFirstResponder()
        return true
    }
}
