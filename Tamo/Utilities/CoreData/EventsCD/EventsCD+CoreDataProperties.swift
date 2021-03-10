//
//  EventsCD+CoreDataProperties.swift
//  Tamo
//
//  Created by Reashed Tulon on 9/3/21.
//
//

import Foundation
import CoreData


extension EventsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventsCD> {
        return NSFetchRequest<EventsCD>(entityName: "EventsCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var userId: String?
    @NSManaged public var eventDate: String?
    @NSManaged public var eventStartTime: String?
    @NSManaged public var eventEndTime: String?
    @NSManaged public var eventType: String?
    @NSManaged public var eventSubject: String?
    @NSManaged public var eventAddress: String?
    @NSManaged public var hasAttachment: Bool
    @NSManaged public var hasLabel: Bool
    @NSManaged public var hasVideo: Bool
    @NSManaged public var rating: String?
    @NSManaged public var important: Bool
    @NSManaged public var isCurrentEvent: Bool
    @NSManaged public var hasSixtyMinSeparator: Bool
    @NSManaged public var prevEventsEndTm: String?
    @NSManaged public var currentEventsStartTm: String?

}
