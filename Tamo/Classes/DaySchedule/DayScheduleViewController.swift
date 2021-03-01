//
//  DayScheduleViewController.swift
//  Tamo
//
//  Created by Reashed Tulon on 25/2/21.
//

import UIKit

class DayScheduleViewController: UIViewController {

    var user: Users?
    var usersArray = [UserCD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("email: \(String(describing: user?.email))")
//        usersArray = CoreDataService.shared.getUser()
        
    }
}
