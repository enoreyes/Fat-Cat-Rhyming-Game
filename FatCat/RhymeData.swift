//
//  RhymeData.swift
//  FatCat
//
//  Created by Amy Reyes on 7/30/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import Foundation
import CoreData

class RhymeData: NSManagedObject {

    @NSManaged var question: String
    @NSManaged var answer: String
    @NSManaged var hint: String
    @NSManaged var level: NSNumber
    @NSManaged var item: NSNumber
    @NSManaged var completed: NSNumber
    @NSManaged var id: NSNumber

    class func createInManagedObjectContext(question: String, answer: String, hint: String, level: NSNumber, item: NSNumber, completed: NSNumber, id: NSNumber, moc: NSManagedObjectContext) -> RhymeData {
        let rhymeData = NSEntityDescription.insertNewObjectForEntityForName("RhymeData", inManagedObjectContext: moc) as! RhymeData
        rhymeData.question = question
        rhymeData.answer = answer
        rhymeData.hint = hint
        rhymeData.level = level
        rhymeData.item = item
        rhymeData.completed = completed
        rhymeData.id = id

        return rhymeData
    }
}


