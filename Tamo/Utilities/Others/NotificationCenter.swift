//
//  NotificationCenter.swift
//  RemoteServerCommunication
//
//  Created by Reashed Tulon on 1/11/18.
//  Copyright © 2018 Reashed Tulon. All rights reserved.
//

import Foundation

let notificationKeyToGetUserdetails = "notificationKeyToGetUserdetails"
let notificationObserverToGetUserdetails = Notification.Name(rawValue: notificationKeyToGetUserdetails)

let notificationKeyToGetEvent = "notificationKeyToGetEvent"
let notificationObserverToGetEvent = Notification.Name(rawValue: notificationKeyToGetEvent)

let notificationKeyToGetEventDetails = "notificationKeyToGetEventDetails"
let notificationObserverToGetEventDetails = Notification.Name(rawValue: notificationKeyToGetEventDetails)

func removeNotificationObserver(viewController: Any) {
    NotificationCenter.default.removeObserver(viewController)
}
