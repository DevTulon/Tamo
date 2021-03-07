//
//  EventsDetails.swift
//  Tamo
//
//  Created by Reashed Tulon on 7/3/21.
//

import UIKit

struct EventsDetails: Codable {
    let id: String?
    let eventId: String?
    let eventComment: String?
    
    init(id: String, eventId: String, eventComment: String) {
        self.id = id
        self.eventId = eventId
        self.eventComment = eventComment
    }
}
