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
    @IBOutlet weak var navBarButton: UIBarButtonItem!
    
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
                    let startTime = getStartTime(events: events)
                    let endTime = getEndTime(startTm: startTime, randomNum: randomNum)
                    let evnt = Events(id: events.id!, userId: events.userId!, eventDate: events.eventDate!, eventStartTime: startTime, eventEndTime: endTime, eventType: events.eventType!, eventSubject: events.eventSubject!, eventAddress: events.eventAddress!, hasAttachment: events.hasAttachment!, hasLabel: events.hasLabel!, hasVideo: events.hasVideo!, rating: events.rating!, important: events.important!)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UserDefaults.standard.removeObject(forKey: "PreviousEventsEndTime")
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
    
    func getEndTime(startTm: String, randomNum: Int) -> String {
        var hour = Int(startTm.prefix(2))
        var min = Int(startTm.components(separatedBy: ":")[1])
        
        if randomNum + min! > 60 {
            min = (randomNum + min!) - 60
            hour = hour! + 1
        } else {
            min = min! + randomNum
        }
        
        let hoursWithZeroInfront = String(format: "%02d", arguments: [hour!])
        let minWithZeroInfront = String(format: "%02d", arguments: [min!])
        
        return "\(hoursWithZeroInfront):\(minWithZeroInfront)"
    }
    
    func getStartTime(events: Events) -> String {
        if let initialDate = events.eventDate {
            let cutFromT = initialDate.components(separatedBy: "T")[1]
            let startTm = String(cutFromT.prefix(5))
            return startTm
        } else {
            return ""
        }
    }
    
    func timeDifferenceBetweenEventsIsMoreThanSixty(events: Events) -> Bool {
//        var boolValue = false
//        if UserDefaults.standard.string(forKey: "PreviousEventsEndTime") == nil {
//            UserDefaults.standard.set(events.eventEndTime, forKey: "PreviousEventsEndTime")
//        } else {
//            //compare PreviousEventsEndTime with current start time
//            //If the time difference is more than 60 min send true otherwise false
//            //Remove userdefault & set with current end time
//            if let currentEventsStartTime = events.eventStartTime {
//                let prevEventsEndTime = UserDefaults.standard.string(forKey: "PreviousEventsEndTime")
//                let timeDiff = getTimeDifferences(previousEventsEndTime: prevEventsEndTime!, currentEventsStartTime: currentEventsStartTime)
//
//                if timeDiff > 60 {
//                    boolValue = true
//                } else {
//                    boolValue = false
//                }
//                UserDefaults.standard.removeObject(forKey: "PreviousEventsEndTime")
//                UserDefaults.standard.set(events.eventEndTime, forKey: "PreviousEventsEndTime")
//            }
//        }
//        return boolValue
        return false
    }
    
    func getTimeDifferences(previousEventsEndTime: String, currentEventsStartTime: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.locale = Locale.current
        //dateFormatter.dateFormat = "kk:mm"
        dateFormatter.dateFormat = "HH:mm"
        
        let previousEventsEndTimeFormat = dateFormatter.date(from: previousEventsEndTime)
        let currentEventsStartTimeFormat = dateFormatter.date(from: currentEventsStartTime)
        
        let calendar = Calendar.current
        let previousEventsEndTimeComponents = calendar.dateComponents([.hour, .minute], from: previousEventsEndTimeFormat!)
        let currentEventsStartTimeComponents = calendar.dateComponents([.hour, .minute], from: currentEventsStartTimeFormat!)

        let difference = calendar.dateComponents([.minute], from: previousEventsEndTimeComponents, to: currentEventsStartTimeComponents).minute!
        return difference
    }
    
    func registerNib() {
        let eventsTableViewCell = UINib(nibName: "EventsTableViewCell", bundle: nil)
        eventsTableView.register(eventsTableViewCell, forCellReuseIdentifier: "EventsTableViewCell")
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
        if timeDifferenceBetweenEventsIsMoreThanSixty(events: eventsArray[indexPath.row]) == true {
            height = 185
        } else {
            height = 130
        }
        return height!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
        
        if timeDifferenceBetweenEventsIsMoreThanSixty(events: eventsArray[indexPath.row]) == true {
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
