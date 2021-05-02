//
//  Order+CoreDataProperties.swift
//  Order Management System
//
//  Created by Apalya on 26/04/21.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var orderNumber: String?
    @NSManaged public var orderDueDate: String?
    @NSManaged public var customerName: String?
    @NSManaged public var customerAddress: String?
    @NSManaged public var customerPhone: String?
    @NSManaged public var orderTotal: Int16

}

extension Order : Identifiable {

}
