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
            dateLabel.textColor = UIColor(red: 77.0/255.0, green: 118/255.0, blue: 142/255.0, alpha: 1.0)
            dayNameLabel.textColor = UIColor(red: 77.0/255.0, green: 118/255.0, blue: 142/255.0, alpha: 1.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
