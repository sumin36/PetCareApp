import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    
    var checkBoxTapped: (() -> Void)?
    var alarmButtonTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        checkBoxImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxTappedAction))
        checkBoxImageView.addGestureRecognizer(tapGesture)
        
        alarmTimeLabel.isHidden = true
    }

    @objc func checkBoxTappedAction() {
        checkBoxTapped?()
    }
    
    @IBAction func alarmButtonTappedAction(_ sender: UIButton) {
        alarmButtonTapped?()
    }
    
    func configureAlarmTime(date: Date?) {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.locale = Locale(identifier: "ko_KR")
            alarmTimeLabel.text = formatter.string(from: date)
            alarmTimeLabel.isHidden = false
        } else {
            alarmTimeLabel.text = nil
            alarmTimeLabel.isHidden = true
        }
    }
}
