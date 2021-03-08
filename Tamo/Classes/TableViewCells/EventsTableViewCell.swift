//
//  EventsTableViewCell.swift
//  Tamo
//
//  Created by Reashed Tulon on 7/3/21.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventSubjectLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var hasLabel: UILabel!
    @IBOutlet weak var hasAttachment: UIImageView!
    @IBOutlet weak var hasVideo: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var hasLabelViewWidthConstraint: NSLayoutConstraint! //65
    @IBOutlet weak var hasLabelWidthConstraint: NSLayoutConstraint! //35
    @IBOutlet weak var hasLabelSeparatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hasAttachmentViewWidthConstraint: NSLayoutConstraint! //55
    @IBOutlet weak var hasAttachmentWidthConstraint: NSLayoutConstraint! //25
    @IBOutlet weak var hasAttachmentSeparatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hasVideoWidthConstraint: NSLayoutConstraint! //25
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var sixtyMinSeparatorContainerView: UIView!
    @IBOutlet weak var lastEventsEndTimeLabel: UILabel!
    @IBOutlet weak var nextEventsStartTimeLabel: UILabel!
    
    @IBOutlet weak var shouldSixtyMinSeparatorContainerViewHiddenBottomConstraint: NSLayoutConstraint! //15
    @IBOutlet weak var sixtyMinSeparatorContainerViewHeightConstraint: NSLayoutConstraint! //40
    
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
    
    func handleSixtyMinSeparatorView(shouldSixtyMinSeparatorContainerViewHidden: Bool, lastEventsEndTime: String, nextEventsStartTime: String) {
        if shouldSixtyMinSeparatorContainerViewHidden == true {
            shouldSixtyMinSeparatorContainerViewHiddenBottomConstraint.constant = 0
            sixtyMinSeparatorContainerViewHeightConstraint.constant = 0
            lastEventsEndTimeLabel.text = lastEventsEndTime
            nextEventsStartTimeLabel.text = nextEventsStartTime
        } else {
            shouldSixtyMinSeparatorContainerViewHiddenBottomConstraint.constant = 15
            sixtyMinSeparatorContainerViewHeightConstraint.constant = 40
            lastEventsEndTimeLabel.text = lastEventsEndTime
            nextEventsStartTimeLabel.text = nextEventsStartTime
        }
        
        layoutIfNeeded()
    }
    
    func setUpCell(events: Events) {
        eventTypeLabel.text = events.eventType
        eventSubjectLabel.text = events.eventSubject
        eventAddressLabel.text = events.eventAddress
        handleBottomViewElements(events: events)
        startTime.text = events.eventStartTime
        endTime.text = events.eventEndTime
        if events.isCurrentEvent == true {
            CommonService.shared.cornerRadius(object: containerView, cornerRadius: 10, borderWidth: 2.0, borderColor: .defaultAppsColor)
            arrowImageView.isHidden = false
        } else {
            CommonService.shared.cornerRadius(object: containerView, cornerRadius: 10, borderWidth: 1.0, borderColor: .clear)
            arrowImageView.isHidden = true
        }
    }
    
    func interfaceUpdate() {
        CommonService.shared.cornerRadius(object: hasLabel, cornerRadius: 10, borderWidth: 0.0, borderColor: .clear)
        CommonService.shared.cornerRadius(object: sixtyMinSeparatorContainerView, cornerRadius: 10, borderWidth: 1.0, borderColor: .clear)
        dropShadow(viewShadow: self.shadowView)
        layoutIfNeeded()
    }
    
    func dropShadow(viewShadow: UIView) {
        viewShadow.layer.shadowColor = UIColor.black.cgColor
        viewShadow.layer.shadowOpacity = 0.4
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 3
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        interfaceUpdate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
