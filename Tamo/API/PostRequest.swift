//
//  PostRequest.swift
//  Tamo
//
//  Created by Reashed Tulon on 26/2/21.
//

import Foundation

let jsonURLForPostData = URL(string: "http://apollo66.com/iOS/Swift/Swift_Library/Server_Related/RemoteServerCommunication/adddata.php")

class PostRequest {
    static let shared = PostRequest()
    private init() { }
    
    func sendPostRequestToServerWithUserModel() {
        var request = URLRequest(url: jsonURLForPostData!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "accept")

        let postString = ["email": "test@tamo.com", "password": "12345678"]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("error \(String(describing: error?.localizedDescription))")
                return
            } else {
    //            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToSendPostRequestToServerWithUserModel), object: error?.localizedDescription, userInfo: nil)
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let parseJson = json {
                        let userId = parseJson["userId"] as? String
                        print("userId \(String(describing: userId))")
                    } else {
                        print("no json!")
                    }
                } catch {
                    print("error \(String(describing: error.localizedDescription))")
                }
                
                
            }
        }
        task.resume()
        
        
        
        
        
        
    //    var request = URLRequest(url: jsonURLForPostData!)
    //    request.httpMethod = "POST"
    //    let postString = "name=\(String(describing: users.name!))&age=\(String(describing: users.age!))"
    //    request.httpBody = postString.data(using: String.Encoding.utf8)
    //    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
    //
    //        if error != nil {
    //            print("error=\(String(describing: error))")
    //            return
    //        } else {
    //            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKeyToSendPostRequestToServerWithUserModel), object: error?.localizedDescription, userInfo: nil)
    //        }
    //    }
    //    task.resume()
        
        
    }
}
