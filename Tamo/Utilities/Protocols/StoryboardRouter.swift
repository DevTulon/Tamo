//
//  StoryboardRouter.swift
//  Somethingfishybd
//
//  Created by Reashed Tulon on 28/7/19.
//  Copyright © 2019 Apollo66. All rights reserved.
//

import Foundation
import UIKit

/*IMPORTANT: */
protocol StoryboardRouter {
    var controller: UIViewController { get }
}

extension StoryboardRouter {
    func getController<T>(T: UIViewController.Type) -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}

enum Storyboards: StoryboardRouter {
    case AuthenticationVC
    case EventsVC
    case EventsDetailsVC
    
    var controller: UIViewController {
        switch self {
            case .AuthenticationVC: return getController(T: AuthenticationViewController.self)
            case .EventsVC: return getController(T: EventsViewController.self)
            case .EventsDetailsVC: return getController(T: EventsDetailsViewController.self)
        }
    }
}
