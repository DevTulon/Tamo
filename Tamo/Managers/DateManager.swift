//
//  DateManager.swift
//  Tamo
//
//  Created by Reashed Tulon on 8/3/21.
//

import Foundation

class DateManager {
    static let shared = DateManager()
    private init() { }
    
    func getCurrentYear() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    func getCurrentMonth() -> String {
        let date = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM"
        let name = nameFormatter.string(from: date)
//        let index = Calendar.current.component(.month, from: currentDate) // format 1, 2, 3, ...
//        print(name)  // April
//        print(index) // 4
        return name
    }
    
    func getCurrentDay() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    
    func getCurrentHourAndMin() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.hour, from: date)
    }
    
    func getCurrentMinute() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.minute, from: date)
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
    
    func getCurrentEvent(startEventTime: String, endEventTime: String) -> Bool {
        var isInBetween: Bool?
        
        let now = Date()
        let startHour = Int(startEventTime.prefix(2))
        let startMin = Int(startEventTime.components(separatedBy: ":")[1])
        
        let endHour = Int(endEventTime.prefix(2))
        let endMin = Int(endEventTime.components(separatedBy: ":")[1])
        
        let startTime = now.dateAt(hours: startHour!, minutes: startMin!)
        let endTime = now.dateAt(hours: endHour!, minutes: endMin!)

        if now >= startTime && now <= endTime {
            isInBetween = true
        } else {
            isInBetween = false
        }
        return isInBetween!
    }
}
