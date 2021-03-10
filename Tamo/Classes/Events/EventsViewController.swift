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
    var eventsArray = [EventsCD]()
    var topScrollerDateArray = [TopScrollerDate]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var timer: Timer?
    @IBOutlet weak var floatingIndicatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionToEvent(notification:)), name: notificationObserverToGetEvent, object: nil)
    }
    
    @objc func notificationActionToEvent(notification: NSNotification) {
        let error = notification.object
        if (error == nil) {
            if notification.userInfo != nil {
                let eventsList = notification.userInfo!["response"] as! [Events]
                self.eventsArray.removeAll()
                CoreDataService.shared.resetCoreDataEntityEvents()
                DispatchQueue.main.async {
                    if eventsList.count == 0 {
                        self.noDataLabel.isHidden = false
                    } else {
                        self.noDataLabel.isHidden = true
                    }
                }
                UserDefaults.standard.removeObject(forKey: "PreviousEventsEndTime")
                for events in eventsList {
                    let randomNum = Int(arc4random_uniform(89) + 10)
                    let startTime = DateManager.shared.getStartTime(events: events)
                    let endTime = DateManager.shared.getEndTime(startTm: startTime, randomNum: randomNum)
                    
                    var hasSixtyMinSeparator = false
                    var prevEventsEndTm = ""
                    var currentEventsStartTm = ""
                    
                    if UserDefaults.standard.string(forKey: "PreviousEventsEndTime") == nil {
                        UserDefaults.standard.set(endTime, forKey: "PreviousEventsEndTime")
                    } else {
                        let prevEventsEndTime = UserDefaults.standard.string(forKey: "PreviousEventsEndTime")
                        let result = DateManager.shared.timeDifferenceBetweenEventsIsMoreThanSixty(previousEventsEndT: prevEventsEndTime!, currentEventsStartT: startTime)
                        
                        hasSixtyMinSeparator = result.0
                        prevEventsEndTm = result.1
                        currentEventsStartTm = result.2
                        
                        UserDefaults.standard.removeObject(forKey: "PreviousEventsEndTime")
                        UserDefaults.standard.set(endTime, forKey: "PreviousEventsEndTime")
                    }
                    
                    let evnt = Events(id: events.id!, userId: events.userId!, eventDate: events.eventDate!, eventStartTime: startTime, eventEndTime: endTime, eventType: events.eventType!, eventSubject: events.eventSubject!, eventAddress: events.eventAddress!, hasAttachment: events.hasAttachment!, hasLabel: events.hasLabel!, hasVideo: events.hasVideo!, rating: events.rating!, important: events.important!, isCurrentEvent: false, hasSixtyMinSeparator: hasSixtyMinSeparator, prevEventsEndTm: prevEventsEndTm, currentEventsStartTm: currentEventsStartTm)
                    self.saveEventsIntoCoreData(events: evnt)
                }
                DispatchQueue.main.async {
                    self.fetchEventsFromCoreData()
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func saveEventsIntoCoreData(events: Events) {
        let dic = ["id": events.id!,
                   "userId": events.userId!,
                    "eventDate": events.eventDate!,
                    "eventStartTime": events.eventStartTime!,
                    "eventEndTime": events.eventEndTime!,
                    "eventType": events.eventType!,
                    "eventSubject": events.eventSubject!,
                    "eventAddress": events.eventAddress!,
                    "hasAttachment": events.hasAttachment!,
                    "hasLabel": events.hasLabel!,
                    "hasVideo": events.hasVideo!,
                    "rating": events.rating!,
                    "important": events.important!,
                    "isCurrentEvent": events.isCurrentEvent!,
                    "hasSixtyMinSeparator": events.hasSixtyMinSeparator!,
                    "prevEventsEndTm": events.prevEventsEndTm!,
                    "currentEventsStartTm": events.currentEventsStartTm!] as [String : Any]
        DispatchQueue.main.async {
            CoreDataService.shared.saveEvent(object: dic)
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
        //print("(user?.avatar)! \((user?.avatar)!)")
        let imageData = try? Data(contentsOf: URL(string : "https://www.w3schools.com/howto/img_avatar.png")!)
        //let imageData = try? Data(contentsOf: URL(string : (user?.avatar)!)!)

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
                self.prepareTableDataForUser(currentUser: currentUser)
            }
        }
    }
    
    func fetchEventsFromCoreData() {
        DispatchQueue.main.async {
            self.eventsArray = CoreDataService.shared.getEvents()
            self.eventsTableView.reloadData()
            self.checkCurrentEvent()
        }
    }
    
    func prepareTableDataForUser(currentUser: UserCD) {
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
    
    func loadTopCollectionView() {
        let allDates = Date().getThirtyDaysFromToday()
        topScrollerDateArray.removeAll()
        
        for (index, singleDate) in allDates.enumerated() {
            let dayName = singleDate.convertDateToDayName()
            let dayNumberValue = Date().convertDateToDayNumber(date: singleDate)
            var isToday = false
            if index == 0 {
                isToday = true
            }
            let topScrollerDate = TopScrollerDate(dateValue: dayNumberValue, dayName: dayName!.uppercased(), isToday: isToday)
            topScrollerDateArray.append(topScrollerDate)
        }
        self.topCollectionView.reloadData()
        floatingIndicatorWidthConstraint.constant = UIScreen.main.bounds.width/8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        loadTopCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
        let eventsWithSeparatorTableViewCell = UINib(nibName: "EventsWithSeparatorTableViewCell", bundle: nil)
        eventsTableView.register(eventsWithSeparatorTableViewCell, forCellReuseIdentifier: "EventsWithSeparatorTableViewCell")
        let topCollectionViewCell = UINib(nibName: "TopCollectionViewCell", bundle: nil)
        topCollectionView.register(topCollectionViewCell, forCellWithReuseIdentifier: "TopCollectionViewCell")
    }
    
    func checkCurrentEvent() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (timer) in
            //check current event
            DispatchQueue.main.async {
                self.eventsArray.removeAll()
                self.eventsArray = CoreDataService.shared.getEvents()
                CoreDataService.shared.resetCoreDataEntityEvents()
                for events in self.eventsArray {
                    let isCurrentEvent = DateManager.shared.getCurrentEvent(startEventTime: events.eventStartTime!, endEventTime: events.eventEndTime!)
                    let dic = ["id": events.id!,
                               "userId": events.userId!,
                                "eventDate": events.eventDate!,
                                "eventStartTime": events.eventStartTime!,
                                "eventEndTime": events.eventEndTime!,
                                "eventType": events.eventType!,
                                "eventSubject": events.eventSubject!,
                                "eventAddress": events.eventAddress!,
                                "hasAttachment": events.hasAttachment,
                                "hasLabel": events.hasLabel,
                                "hasVideo": events.hasVideo,
                                "rating": events.rating!,
                                "important": events.important,
                                "isCurrentEvent": isCurrentEvent,
                                "hasSixtyMinSeparator": events.hasSixtyMinSeparator,
                                "prevEventsEndTm": events.prevEventsEndTm!,
                                "currentEventsStartTm": events.currentEventsStartTm!] as [String : Any]
                    CoreDataService.shared.saveEvent(object: dic)
                }
                self.eventsArray.removeAll()
                self.eventsArray = CoreDataService.shared.getEvents()
                self.eventsTableView.reloadData()
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
        if eventsArray[indexPath.row].hasSixtyMinSeparator == true {
            height = 185
        } else {
            height = 130
        }

        return height!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if eventsArray[indexPath.row].hasSixtyMinSeparator == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsWithSeparatorTableViewCell") as! EventsWithSeparatorTableViewCell
            cell.selectionStyle = .none
            cell.setUpCell(events: eventsArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
            cell.selectionStyle = .none
            cell.setUpCell(events: eventsArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventsDetailsViewController = Storyboards.EventsDetailsVC.controller as! EventsDetailsViewController
        eventsDetailsViewController.events = eventsArray[indexPath.row]
        pushViewController(T: eventsDetailsViewController)
    }
}

extension EventsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topScrollerDateArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var edgeInsetsTop, edgeInsetsBottom, edgeInsetsLeft, edgeInsetsRight: CGFloat?
        edgeInsetsTop = 0
        edgeInsetsBottom = 0
        edgeInsetsLeft = 0
        edgeInsetsRight = 0
        return UIEdgeInsets(top: edgeInsetsTop!, left: edgeInsetsLeft!, bottom: edgeInsetsBottom!, right: edgeInsetsRight!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat?
        var height: CGFloat?
        width = UIScreen.main.bounds.width/8
        height = topCollectionView.bounds.height
        return CGSize(width: width!, height: height!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
        cell.setUpCell(topScrollerDate: topScrollerDateArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.topCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.topCollectionView == scrollView {
            targetContentOffset.pointee = scrollView.contentOffset
            var indexes = self.topCollectionView.indexPathsForVisibleItems
            indexes.sort()
            var index = indexes.first!
            let cell = self.topCollectionView.cellForItem(at: index)!
            let position = self.topCollectionView.contentOffset.x - cell.frame.origin.x
            if position > cell.frame.size.width/2{
               index.row = index.row+1
            }
            self.topCollectionView.scrollToItem(at: index, at: .left, animated: true)
        }
    }
}
