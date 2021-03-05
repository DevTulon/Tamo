//
//  DayScheduleViewController.swift
//  Tamo
//
//  Created by Reashed Tulon on 25/2/21.
//

import UIKit

class EventsViewController: UIViewController {

    var user: Users?
    var usersArray = [UserCD]()
    var eventsArray = [Events]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionToEvent(notification:)), name: notificationObserverToGetEvent, object: nil)
    }
    
    @objc func notificationActionToEvent(notification: NSNotification) {
        let error = notification.object
        if (error == nil) {
            if notification.userInfo != nil {
                eventsArray = notification.userInfo!["response"] as! [Events]
                DispatchQueue.main.async {
                    self.eventsTableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func initialViewSetUp() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationObserver()
        initialViewSetUp()
        activityIndicator.startAnimating()
        GetRequest.shared.retrieveDataFromEventList(userID: UserDefaults.standard.string(forKey: "userID")!)
    }
}

extension EventsViewController : UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
        cell.selectionStyle = .none
        cell.setUpCell(events: eventsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
