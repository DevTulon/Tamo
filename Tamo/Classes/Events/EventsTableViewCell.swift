//
//  EventsTableViewCell.swift
//  Tamo
//
//  Created by Reashed Tulon on 3/3/21.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventSubjectLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var hasLabel: UILabel!
    @IBOutlet weak var hasAttachment: UIImageView!
    @IBOutlet weak var hasVideo: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    @IBOutlet weak var hasLabelViewWidthConstraint: NSLayoutConstraint! //65
    @IBOutlet weak var hasLabelWidthConstraint: NSLayoutConstraint! //35
    @IBOutlet weak var hasLabelSeparatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hasAttachmentViewWidthConstraint: NSLayoutConstraint! //55
    @IBOutlet weak var hasAttachmentWidthConstraint: NSLayoutConstraint! //25
    @IBOutlet weak var hasAttachmentSeparatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hasVideoWidthConstraint: NSLayoutConstraint! //25
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    func handleBottomViewElements(events: Events) {
        if events.hasLabel == true {
            hasLabelViewWidthConstraint.constant = 65
            hasLabelWidthConstraint.constant = 35
            
            if events.hasAttachment == true || events.hasVideo == true {
                hasLabelSeparatorWidthConstraint.constant = 1
            } else {
                hasLabelSeparatorWidthConstraint.constant = 0
            }
        } else {
            hasLabelViewWidthConstraint.constant = 0
            hasLabelWidthConstraint.constant = 0
            hasLabelSeparatorWidthConstraint.constant = 0
        }
        
        if events.hasAttachment == true {
            hasAttachmentViewWidthConstraint.constant = 55
            hasAttachmentWidthConstraint.constant = 25
            
            if events.hasVideo == true {
                hasAttachmentSeparatorWidthConstraint.constant = 1
            } else {
                hasAttachmentSeparatorWidthConstraint.constant = 0
            }
        } else {
            hasAttachmentViewWidthConstraint.constant = 0
            hasAttachmentWidthConstraint.constant = 0
            hasAttachmentSeparatorWidthConstraint.constant = 0
        }
        
        if events.hasVideo == true {
            hasVideoWidthConstraint.constant = 25
        } else {
            hasVideoWidthConstraint.constant = 0
        }

        ratingsLabel.text = events.rating
        layoutIfNeeded()
    }
    
    func setStartAndEndTime(events: Events) {
        if let initialDate = events.eventDate {
            let cutFromT = initialDate.components(separatedBy: "T")[1]
            let startTm = cutFromT.prefix(5)
            startTime.text = String(startTm)
            endTime.text = getEndTime(startTm: String(startTm))
        }
    }
    
    func getEndTime(startTm: String) -> String {
        var hour = Int(startTm.prefix(2))
        var min = Int(startTm.components(separatedBy: ":")[1])
        let randomNum = Int(arc4random_uniform(49) + 10)
        print("randomNum \(randomNum)")
        if randomNum + min! > 60 {
            min = (randomNum + min!) - 60
            hour = hour! + 1
        } else {
            min = min! + randomNum
        }

        return "\(hour!):\(min!)"
    }
    
    func setUpCell(events: Events) {
        eventTypeLabel.text = events.eventType
        eventSubjectLabel.text = events.eventSubject
        eventAddressLabel.text = events.eventAddress
        handleBottomViewElements(events: events)
        setStartAndEndTime(events: events)
    }
    
    func interfaceUpdate() {
        CommonService.shared.cornerRadius(object: containerView, cornerRadius: 10, borderWidth: 1.0, borderColor: .clear)
        CommonService.shared.cornerRadius(object: hasLabel, cornerRadius: 10, borderWidth: 0.0, borderColor: .clear)
        layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        interfaceUpdate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
