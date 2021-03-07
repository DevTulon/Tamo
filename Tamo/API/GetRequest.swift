//
//  GetRequest.swift
//  Tamo
//
//  Created by Reashed Tulon on 26/2/21.
//

import Foundation

let userDataURL = "https://6033d74f843b150017931b4a.mockapi.io/api/v1/authenticate"

class GetRequest {
    static let shared = GetRequest()
    private init() { }
    
    func retrieveDataFromUserList() {
        guard let url = URL(string: userDataURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                do {
                    let users = try JSONDecoder().decode([Users].self, from: data)
                    let notificationDic = ["response": users]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetUserdetails), object: error, userInfo: notificationDic)
                } catch let error {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetUserdetails), object: error.localizedDescription, userInfo: nil)
                }
            } else if let error = error {
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetUserdetails), object: error.localizedDescription, userInfo: nil)
            }
            
        }.resume()
    }
    
    func retrieveDataFromEventList(userID: String) {
        let eventDataURL = "https://6033d74f843b150017931b4a.mockapi.io/api/v1/authenticate/\(String(describing: userID))/events"
        guard let url = URL(string: eventDataURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let events = try JSONDecoder().decode([Events].self, from: data)
                    let notificationDic = ["response": events]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetEvent), object: error, userInfo: notificationDic)
                } catch let error {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetEvent), object: error.localizedDescription, userInfo: nil)
                }
            } else if let error = error {
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetEvent), object: error.localizedDescription, userInfo: nil)
            }
            
        }.resume()
    }
    
    func retrieveDataFromEventDetailsList(userID: String, eventId: String) {
        let eventDetailsDataURL = "https://6033d74f843b150017931b4a.mockapi.io/api/v1/authenticate/\(String(describing: userID))/events/\(String(describing: eventId))/event"
        guard let url = URL(string: eventDetailsDataURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let events = try JSONDecoder().decode([EventsDetails].self, from: data)
                    let notificationDic = ["response": events]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetEventDetails), object: error, userInfo: notificationDic)
                } catch let error {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetEventDetails), object: error.localizedDescription, userInfo: nil)
                }
            } else if let error = error {
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToGetEventDetails), object: error.localizedDescription, userInfo: nil)
            }
            
        }.resume()
    }
}

