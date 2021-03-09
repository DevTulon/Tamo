//
//  EventDetailsViewController.swift
//  Tamo
//
//  Created by Reashed Tulon on 25/2/21.
//

import UIKit

class EventsDetailsViewController: UIViewController {

    var events: Events?
    var eventsDetailsArray = [EventsDetails]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eventsDetailsTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionToEventDetails(notification:)), name: notificationObserverToGetEventDetails, object: nil)
    }
    
    @objc func notificationActionToEventDetails(notification: NSNotification) {
        let error = notification.object
        if (error == nil) {
            if notification.userInfo != nil {
                let eventsDtlsArray = notification.userInfo!["response"] as! [EventsDetails]
                
                self.eventsDetailsArray.removeAll()
                for eventsDt in eventsDtlsArray {
                    let eventDet = EventsDetails(id: eventsDt.id!, eventId: eventsDt.eventId!, eventComment: eventsDt.eventComment!)
                    self.eventsDetailsArray.append(eventDet)
                }
                let emptyEvnt = EventsDetails(id: "", eventId: "", eventComment: "")
                self.eventsDetailsArray.insert(emptyEvnt, at: 0)
                
                DispatchQueue.main.async {
                    if self.eventsDetailsArray.count == 1 {
                        self.noDataLabel.isHidden = false
                    } else {
                        self.noDataLabel.isHidden = true
                    }
                    self.eventsDetailsTableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func registerNib() {
        let eventsTableViewCell = UINib(nibName: "EventsTableViewCell", bundle: nil)
        eventsDetailsTableView.register(eventsTableViewCell, forCellReuseIdentifier: "EventsTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events Details"
        createNotificationObserver()
        registerNib()
        activityIndicator.startAnimating()
        GetRequest.shared.retrieveDataFromEventDetailsList(userID: UserDefaults.standard.string(forKey: "userID")!, eventId: (events?.id)!)
    }
}

extension EventsDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsDetailsArray.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat?
        if indexPath.row == 0 {
            cellHeight = 130
        } else {
            cellHeight = 60
        }
        return cellHeight!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
            cell.selectionStyle = .none
            cell.setUpCell(events: events!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsDetailsTableViewCell") as! EventsDetailsTableViewCell
            cell.selectionStyle = .none
            cell.setUpCell(eventsDetails: eventsDetailsArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
