//
//  GameData.swift
//  FatCat
//
//  Created by Amy Reyes on 8/5/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import Foundation
import CoreData

class GameData: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var completed: NSNumber
    @NSManaged var level: NSNumber
    @NSManaged var item: NSNumber

    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: NSNumber, completed: NSNumber, level: NSNumber, item: NSNumber) -> GameData {
        
        let gameData = NSEntityDescription.insertNewObjectForEntityForName("GameData", inManagedObjectContext: moc) as! GameData
        gameData.id = id
        gameData.completed = completed
        gameData.level = level
        gameData.item = item
        
        return gameData
    }
    
}
