//
//  CoreDataManager.swift
//  AquariumManagementSystem
//
//  Created by Reashed Tulon on 31/7/19.
//  Copyright © 2019 Apollo66. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataService {

    static var shared = CoreDataService()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveUser(object: [String :Any]) {
        let userCD = NSEntityDescription.insertNewObject(forEntityName: "UserCD", into: context!) as! UserCD
        
        userCD.userId = object["userId"] as? String
        userCD.authToken = object["authToken"] as? String
        userCD.email = object["email"] as? String
        userCD.password = object["password"] as? String
        userCD.avatar = object["avatar"] as? String
        userCD.firstName = object["firstName"] as? String
        userCD.lastName = object["lastName"] as? String
        
        do {
            try context?.save()
//            print("Coredata saved at \(String(describing: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last))")
        } catch {
            print("Data is not saved!!")
        }
    }
    
    func getUser() -> [UserCD] {
        var userCD = [UserCD]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserCD")
        
        do {
            userCD = try context?.fetch(fetchRequest) as! [UserCD]
        } catch {
            print ("Can not get data!!")
        }
        
        return userCD
    }
    
    func saveEvent(object: [String :Any]) {
        let eventsCD = NSEntityDescription.insertNewObject(forEntityName: "EventsCD", into: context!) as! EventsCD
        eventsCD.id = object["id"] as? String
        eventsCD.userId = object["userId"] as? String
        eventsCD.eventDate = object["eventDate"] as? String
        eventsCD.eventStartTime = object["eventStartTime"] as? String
        eventsCD.eventEndTime = object["eventEndTime"] as? String
        eventsCD.eventType = object["eventType"] as? String
        eventsCD.eventSubject = object["eventSubject"] as? String
        eventsCD.eventAddress = object["eventAddress"] as? String
        eventsCD.hasAttachment = (object["hasAttachment"] as? Bool)!
        eventsCD.hasLabel = (object["hasLabel"] as? Bool)!
        eventsCD.hasVideo = (object["hasVideo"] as? Bool)!
        eventsCD.rating = object["rating"] as? String
        eventsCD.important = (object["important"] as? Bool)!
        eventsCD.isCurrentEvent = (object["isCurrentEvent"] as? Bool)!
        eventsCD.hasSixtyMinSeparator = (object["hasSixtyMinSeparator"] as? Bool)!
        eventsCD.prevEventsEndTm = object["prevEventsEndTm"] as? String
        eventsCD.currentEventsStartTm = object["currentEventsStartTm"] as? String
        do {
            try context?.save()
            print("Coredata saved at \(String(describing: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last))")
        } catch {
            print("Data is not saved!!")
        }
    }
    
    func getEvents() -> [EventsCD] {
        var eventsCD = [EventsCD]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EventsCD")
        
        do {
            eventsCD = try context?.fetch(fetchRequest) as! [EventsCD]
        } catch {
            print ("Can not get data!!")
        }
        
        return eventsCD
    }
    
//    func updateUser(userId: String, authToken: String?, email: String?, password: String?, avatar: String?, firstName: String?, lastName: String?) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
//        fetchRequest.predicate = NSPredicate(format: "userId = %@", userId)
//
//        do {
//            let object = try context!.fetch(fetchRequest)
//            if object.count == 1 {
//                let objectUpdate = object.first as! NSManagedObject
//
//                if userName != nil {
//                    objectUpdate.setValue(userName, forKey: "userName")
//                } else if userProfileImageURL != nil && userProfileImageURL != "nil" {
//                    objectUpdate.setValue(userProfileImageURL, forKey: "userProfileImageURL")
//                } else if userProfileImageURL == "nil" {
//                    objectUpdate.setValue("", forKey: "userProfileImageURL")
//                } else if address != nil {
//                    objectUpdate.setValue(address, forKey: "address")
//                } else if authCredentialID != nil {
//                    objectUpdate.setValue(authCredentialID, forKey: "authCredentialID")
//                } else if password != nil {
//                    objectUpdate.setValue(password, forKey: "password")
//                } else if isEmailVerified != nil {
//                    objectUpdate.setValue(isEmailVerified, forKey: "isEmailVerified")
//                }
//
//                do {
//                    try context!.save()
//                }
//                catch {
//                    print(error)
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
    
    func resetCoreDataEntityUsers() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func resetCoreDataEntityEvents() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventsCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch {
            print ("There was an error")
        }
    }
}
