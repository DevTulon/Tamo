//
//  TopScrollerDate.swift
//  Tamo
//
//  Created by Reashed Tulon on 9/3/21.
//

import Foundation

struct TopScrollerDate: Codable {
    let dateValue: String?
    let dayName: String?
    let isToday: Bool?
    
    init(dateValue: String, dayName: String, isToday: Bool) {
        self.dateValue = dateValue
        self.dayName = dayName
        self.isToday = isToday
    }
}
