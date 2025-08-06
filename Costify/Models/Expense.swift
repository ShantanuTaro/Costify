//
//  Expense.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
//

import Foundation
import CoreData

public class Expense: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var title: String
    @NSManaged public var amount: Double
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var note: String?
}
