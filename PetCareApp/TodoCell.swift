import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    var checkBoxTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        checkBoxImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxTappedAction))
        checkBoxImageView.addGestureRecognizer(tapGesture)
    }

    @objc func checkBoxTappedAction() {
        checkBoxTapped?()
    }
}
