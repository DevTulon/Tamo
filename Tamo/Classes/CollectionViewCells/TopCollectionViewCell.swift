//
//  TopCollectionViewCell.swift
//  Tamo
//
//  Created by Reashed Tulon on 9/3/21.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    
    func setUpCell(topScrollerDate: TopScrollerDate) {
        dateLabel.text = topScrollerDate.dateValue
        dayNameLabel.text = topScrollerDate.dayName
        
        if topScrollerDate.isToday == true {
            dateLabel.textColor = .white
            dayNameLabel.textColor = .white
        } else {
            dateLabel.textColor = .topScrollerDateTextColor
            dayNameLabel.textColor = .topScrollerDateTextColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
