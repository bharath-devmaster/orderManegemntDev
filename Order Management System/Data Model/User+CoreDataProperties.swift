//
//  User+CoreDataProperties.swift
//  Order Management System
//
//  Created by Apalya on 26/04/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userName: String?
    @NSManaged public var userPassword: String?
    @NSManaged public var userAddress: String?
    @NSManaged public var userPhone: String?

}

extension User : Identifiable {

}
