//
//  CalendarCell.swift
//  PetCareApp
//
//  Created by macso on 2025/06/10.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.black : UIColor.clear
            dayLabel.textColor = isSelected ? UIColor.white : UIColor.label
            contentView.layer.cornerRadius = contentView.frame.width / 2
            contentView.layer.masksToBounds = true
        }
    }
}
