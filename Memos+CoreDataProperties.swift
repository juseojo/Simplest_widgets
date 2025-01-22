//
//  Memos+CoreDataProperties.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 1/22/25.
//
//

import Foundation
import CoreData


extension Memos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memos> {
        return NSFetchRequest<Memos>(entityName: "Memos")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: Date?

}

extension Memos : Identifiable {

}
