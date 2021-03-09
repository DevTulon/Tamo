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
    
    func timeDifferenceBetweenEventsIsMoreThanSixty(previousEventsEndT: String, currentEventsStartT: String) -> (Bool, String, String) {
        var boolValue = false
        var prevEventsEndTm = ""
        var currentEventsStartTm = ""
        
        let timeDiff = getTimeDifferences(previousEventsEndTime: previousEventsEndT, currentEventsStartTime: currentEventsStartT)

        if timeDiff > 60 {
            boolValue = true
            prevEventsEndTm = previousEventsEndT
            currentEventsStartTm = currentEventsStartT
        } else {
            boolValue = false
            prevEventsEndTm = ""
            currentEventsStartTm = ""
        }
        
        return (boolValue, prevEventsEndTm, currentEventsStartTm)
    }
    
    func getTimeDifferences(previousEventsEndTime: String, currentEventsStartTime: String) -> Int {
        let now = Date()
        
        let currentEventsStartHour = Int(currentEventsStartTime.prefix(2))
        let currentEventsStartMin = Int(currentEventsStartTime.components(separatedBy: ":")[1])
        
        let previousEventsEndHour = Int(previousEventsEndTime.prefix(2))
        let previousEventsEndMin = Int(previousEventsEndTime.components(separatedBy: ":")[1])
        
        let currentEventsStart = now.dateAt(hours: currentEventsStartHour!, minutes: currentEventsStartMin!)
        let previousEventsEnd = now.dateAt(hours: previousEventsEndHour!, minutes: previousEventsEndMin!)
        
        return getMinutesDifferenceFromTwoDates(bigTime: previousEventsEnd, smallTime: currentEventsStart)
    }
    
    func getMinutesDifferenceFromTwoDates(bigTime: Date, smallTime: Date) -> Int {
        let diff = Int(bigTime.timeIntervalSince1970 - smallTime.timeIntervalSince1970)
        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        let totalMin = (hours * 60) + minutes
        print("minutesminutes\(abs(totalMin))")
        return abs(totalMin)
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





//func getTimeDifferences(previousEventsEndTime: String, currentEventsStartTime: String) -> Int {
//    let now = Date()
//
//    let currentEventsStartHour = Int(currentEventsStartTime.prefix(2))
//    let currentEventsStartMin = Int(currentEventsStartTime.components(separatedBy: ":")[1])
//
//    let previousEventsEndHour = Int(previousEventsEndTime.prefix(2))
//    let previousEventsEndMin = Int(previousEventsEndTime.components(separatedBy: ":")[1])
//
//    let currentEventsStart = now.dateAt(hours: currentEventsStartHour!, minutes: currentEventsStartMin!)
//    let previousEventsEnd = now.dateAt(hours: previousEventsEndHour!, minutes: previousEventsEndMin!)
//
//    return getMinutesDifferenceFromTwoDates(bigTime: previousEventsEnd, smallTime: currentEventsStart)
//}
