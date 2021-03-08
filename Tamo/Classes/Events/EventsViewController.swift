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
    @IBOutlet weak var noDataLabel: UILabel!
    var timer: Timer?
    
    func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionToEvent(notification:)), name: notificationObserverToGetEvent, object: nil)
    }
    
    @objc func notificationActionToEvent(notification: NSNotification) {
        let error = notification.object
        if (error == nil) {
            if notification.userInfo != nil {
                let eventsList = notification.userInfo!["response"] as! [Events]
                DispatchQueue.main.async {
                    if eventsList.count == 0 {
                        self.noDataLabel.isHidden = false
                    } else {
                        self.noDataLabel.isHidden = true
                    }
                }
                self.eventsArray.removeAll()
                for events in eventsList {
                    let randomNum = Int(arc4random_uniform(49) + 10)
                    let startTime = DateManager.shared.getStartTime(events: events)
                    let endTime = DateManager.shared.getEndTime(startTm: startTime, randomNum: randomNum)
                    let evnt = Events(id: events.id!, userId: events.userId!, eventDate: events.eventDate!, eventStartTime: startTime, eventEndTime: endTime, eventType: events.eventType!, eventSubject: events.eventSubject!, eventAddress: events.eventAddress!, hasAttachment: events.hasAttachment!, hasLabel: events.hasLabel!, hasVideo: events.hasVideo!, rating: events.rating!, important: events.important!, isCurrentEvent: false)
                    self.eventsArray.append(evnt)
                }
                DispatchQueue.main.async {
                    self.eventsTableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func setNavBarButtonProfilePic() {
        //Avatar
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        print("(user?.avatar)! \((user?.avatar)!)")
//        let imageData = try? Data(contentsOf: URL(string : "https://www.w3schools.com/howto/img_avatar.png")!)
        let imageData = try? Data(contentsOf: URL(string : (user?.avatar)!)!)

        if let imageData = imageData, let image =  UIImage(data: imageData)?.resizeImage(to: button.frame.size) {
            button.setBackgroundImage(image, for: .normal)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        //Title
        let longTitleLabel = UILabel()
        longTitleLabel.text = "\(DateManager.shared.getCurrentYear()) \(DateManager.shared.getCurrentMonth().uppercased())"
        longTitleLabel.font = UIFont(name:"Helvetica-Bold", size:17)
        longTitleLabel.textColor = .white
        longTitleLabel.sizeToFit()

        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func fetchUserFromCoreData() {
        usersArray.removeAll()
        usersArray = CoreDataService.shared.getUser()
        DispatchQueue.global(qos: .userInteractive).async {
            for currentUser in self.usersArray {
                self.prepareTableData(currentUser: currentUser)
            }
        }
    }
    
    func prepareTableData(currentUser: UserCD) {
        if let cuserId = currentUser.userId,
            let cauthToken = currentUser.authToken,
            let cemail = currentUser.email,
            let cpassword = currentUser.password,
            let cavatar = currentUser.avatar,
            let cfirstName = currentUser.firstName,
            let clastName = currentUser.lastName {
            self.user = Users(userId: cuserId, authToken: cauthToken, email: cemail, password: cpassword, avatar: cavatar, firstName: cfirstName, lastName: clastName)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        checkCurrentEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UserDefaults.standard.removeObject(forKey: "PreviousEventsEndTime")
        self.navigationController?.navigationBar.shouldRemoveShadow(false)
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationObserver()
        registerNib()
        fetchUserFromCoreData()
        setNavBarButtonProfilePic()
        activityIndicator.startAnimating()
        GetRequest.shared.retrieveDataFromEventList(userID: UserDefaults.standard.string(forKey: "userID")!)
    }
    
    func registerNib() {
        let eventsTableViewCell = UINib(nibName: "EventsTableViewCell", bundle: nil)
        eventsTableView.register(eventsTableViewCell, forCellReuseIdentifier: "EventsTableViewCell")
    }
    
    func checkCurrentEvent() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
            //check current event
            DispatchQueue.main.async {
                if self.eventsArray.count > 0 {
                    let eventsArrayList = self.eventsArray
                    self.eventsArray.removeAll()
                    
                    var isCurrentEventFound = false
                    for events in eventsArrayList {
                        let isCurrentEvent = DateManager.shared.getCurrentEvent(startEventTime: events.eventStartTime!, endEventTime: events.eventEndTime!)
                        if isCurrentEvent == true {
                            isCurrentEventFound = true
                        }
                        let evnt = Events(id: events.id!, userId: events.userId!, eventDate: events.eventDate!, eventStartTime: events.eventStartTime!, eventEndTime: events.eventEndTime!, eventType: events.eventType!, eventSubject: events.eventSubject!, eventAddress: events.eventAddress!, hasAttachment: events.hasAttachment!, hasLabel: events.hasLabel!, hasVideo: events.hasVideo!, rating: events.rating!, important: events.important!, isCurrentEvent: isCurrentEvent)
                        self.eventsArray.append(evnt)
                    }
                    if isCurrentEventFound == true {
                        self.eventsTableView.reloadData()
                    }
                }
            }
        }
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
        var height: CGFloat?
        if DateManager.shared.timeDifferenceBetweenEventsIsMoreThanSixty(events: eventsArray[indexPath.row]) == true {
            height = 185
        } else {
            height = 130
        }
        return height!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
        
        if DateManager.shared.timeDifferenceBetweenEventsIsMoreThanSixty(events: eventsArray[indexPath.row]) == true {
            cell.handleSixtyMinSeparatorView(shouldSixtyMinSeparatorContainerViewHidden: false, lastEventsEndTime: "", nextEventsStartTime: "")
        } else {
            cell.handleSixtyMinSeparatorView(shouldSixtyMinSeparatorContainerViewHidden: true, lastEventsEndTime: "", nextEventsStartTime: "")
        }
        
        cell.selectionStyle = .none
        cell.setUpCell(events: eventsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventsDetailsViewController = Storyboards.EventsDetailsVC.controller as! EventsDetailsViewController
        eventsDetailsViewController.events = eventsArray[indexPath.row]
        pushViewController(T: eventsDetailsViewController)
    }
}
