//
//  Date+Extention.swift
//  Tamo
//
//  Created by Reashed Tulon on 8/3/21.
//

import Foundation

extension Date {
    func dateAt(hours: Int, minutes: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        //get the month/day/year componentsfor today's date.
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
    
    mutating func addDays(n: Int) {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func firstDayOfTheMonth() -> Date {
//        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        return Date()
    }
    
    func getThirtyDaysFromToday() -> [Date] {
        var days = [Date]()
        let calendar = Calendar.current
    
        let range = calendar.range(of: .day, in: .month, for: self)!
        var day = firstDayOfTheMonth()
        
        for _ in 1...range.count {
            days.append(day)
            day.addDays(n: 1)
        }
        return days
    }
    
    func convertDateToDayName() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self)
    }
    
    func convertDateToDayNumber(date: Date) -> String {
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        return String(calanderDate.day!)
    }
}
