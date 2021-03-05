//
//  CommonService.swift
//  Tamo
//
//  Created by Reashed Tulon on 3/3/21.
//

import Foundation
import UIKit

class CommonService {
    static let shared = CommonService()
    private init() { }
    
    func gotoEventsViewController() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let eventsViewController = Storyboards.EventsVC.controller as! EventsViewController
        let navigationController = UINavigationController(rootViewController: eventsViewController)
        appdelegate.window!.rootViewController = navigationController
    }
    
    func gotoSignInViewController() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let authenticationViewController = Storyboards.AuthenticationVC.controller as! AuthenticationViewController
        let navigationController = UINavigationController(rootViewController: authenticationViewController)
        appdelegate.window!.rootViewController = navigationController
    }
    
    func cornerRadius<T: UIView>(object: T, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        object.layer.borderWidth = borderWidth
        object.layer.masksToBounds = false
        object.layer.borderColor = borderColor.cgColor
        object.layer.cornerRadius = cornerRadius
        object.clipsToBounds = true
    }
}
