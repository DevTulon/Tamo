//
//  EventsDetailsTableViewCell.swift
//  Tamo
//
//  Created by Reashed Tulon on 7/3/21.
//

import UIKit

class EventsDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func setUpCell(eventsDetails: EventsDetails) {
        idLabel.text = eventsDetails.id
        commentLabel.text = eventsDetails.eventComment
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
