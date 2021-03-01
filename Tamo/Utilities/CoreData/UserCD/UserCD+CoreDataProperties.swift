//
//  UserCD+CoreDataProperties.swift
//  Tamo
//
//  Created by Reashed Tulon on 1/3/21.
//
//

import Foundation
import CoreData


extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var userId: String?
    @NSManaged public var authToken: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var avatar: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}
