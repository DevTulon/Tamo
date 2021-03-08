//
//  Events.swift
//  Tamo
//
//  Created by Reashed Tulon on 2/3/21.
//

import UIKit

struct Events: Codable {
    let id: String?
    let userId: String?
    let eventDate: String?
    let eventStartTime: String?
    let eventEndTime: String?
    let eventType: String?
    let eventSubject: String?
    let eventAddress: String?
    let hasAttachment: Bool?
    let hasLabel: Bool?
    let hasVideo: Bool?
    let rating: String?
    let important: Bool?
    let isCurrentEvent: Bool?
    
    init(id: String, userId: String, eventDate: String, eventStartTime: String, eventEndTime: String, eventType: String, eventSubject: String, eventAddress: String, hasAttachment: Bool, hasLabel: Bool, hasVideo: Bool, rating: String, important: Bool, isCurrentEvent: Bool) {
        self.id = id
        self.userId = userId
        self.eventDate = eventDate
        self.eventStartTime = eventStartTime
        self.eventEndTime = eventEndTime
        self.eventType = eventType
        self.eventSubject = eventSubject
        self.eventAddress = eventAddress
        self.hasAttachment = hasAttachment
        self.hasLabel = hasLabel
        self.hasVideo = hasVideo
        self.rating = rating
        self.important = important
        self.isCurrentEvent = isCurrentEvent
    }
}
