//
//  GetRequest.swift
//  Tamo
//
//  Created by Reashed Tulon on 26/2/21.
//

import Foundation

let getDataURL = "https://6033d74f843b150017931b4a.mockapi.io/api/v1/authenticate"

class GetRequest {
    static let shared = GetRequest()
    private init() { }
    
    func retrieveDataFromUserTable() {
        guard let url = URL(string: getDataURL) else { return }
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
}
