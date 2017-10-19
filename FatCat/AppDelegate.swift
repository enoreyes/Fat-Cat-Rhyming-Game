//
//  AppDelegate.swift
//  FatCat
//
//  Created by Amy Reyes on 7/30/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaults = NSUserDefaults.standardUserDefaults()
    var completedArray: [String: [Int]] = ["1": [], "2": [], "3": [], "4": [], "5": [], "6": [], "7": [], "8": []]
    var rhymeArray:Array<AnyObject> = []
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if let hasRun = self.defaults.stringForKey(Constants.userConstants.hasRun) {
        } else {
            self.defaults.setValue(5, forKey: Constants.userConstants.numberOfHints)
            initCoreData()
            self.defaults.setValue(true, forKey: Constants.userConstants.hasRun)
        }
        
        if let hasRunPostUpdate = self.defaults.stringForKey(Constants.userConstants.hasRunPostUpdate) {
        } else {
            initPostUpdateData()
            self.defaults.setValue(true, forKey: Constants.userConstants.hasRunPostUpdate)
        }
        
        return true
    }
    
    func initPostUpdateData() {
        var x = 0
        for i in 8...20 {
            for d in 1...20 {
                let gameData = NSEntityDescription.insertNewObjectForEntityForName("GameData", inManagedObjectContext: self.managedObjectContext!) as! GameData
                gameData.id = x
                gameData.level = i
                gameData.completed = false
                gameData.item = d
                x++
                var error: NSError? = nil
                do {
                    try self.managedObjectContext!.save()
                } catch let error1 as NSError {
                    error = error1
                    //                    print("it didn't write")
                }
            }
        }
    }
    
    func initCoreData() {
        //var gameData = NSEntityDescription.insertNewObjectForEntityForName("GameData", inManagedObjectContext: self.managedObjectContext!) as! GameData
        var x = 0
        for i in 1...7 {
//            print(i)
            
            for d in 1...20 {
//                print("level: \(i)  item: \(d)")
                
                let gameData = NSEntityDescription.insertNewObjectForEntityForName("GameData", inManagedObjectContext: self.managedObjectContext!) as! GameData
                gameData.id = x
                gameData.level = i
                gameData.completed = false
                gameData.item = d
                x++
                var error: NSError? = nil
                do {
                    try self.managedObjectContext!.save()
                } catch let error1 as NSError {
                    error = error1
//                    print("it didn't write")
                }
                
            }
            
        }
    }
    
    func markCompleted (level: NSNumber, item: NSNumber) {
        var context: NSManagedObjectContext = self.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "GameData")
        fetchRequest.predicate = NSPredicate(format: "level = %@ && item = %@", level, item)
        if let fetchResults = (try? self.managedObjectContext!.executeFetchRequest(fetchRequest)) as? [NSManagedObject] {
            if fetchResults.count != 0 {
                let managedObject = fetchResults[0]
                managedObject.setValue(true, forKey: "completed")
                
                
                
                //var error:NSError? = nil
                
                
                if (managedObjectContext?.hasChanges != nil) {
                    
                    do {
                        try self.managedObjectContext!.save()
                    } catch {
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                        abort()
                    }
                    
                    
                }
                
                
                
//                if((self.managedObjectContext?.save()) != nil) {
//                    print("success")
//                } else {
//                    print("failure")
//                }

                
                
            }
        }
    }
    
    func completedInLevel (level: NSNumber) -> Int {
        var context: NSManagedObjectContext = self.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "GameData")
        var numberCompleted = 0
        fetchRequest.predicate = NSPredicate(format: "level = %@ && completed = true", level)
        if let fetchResults = (try? self.managedObjectContext!.executeFetchRequest(fetchRequest)) as? [NSManagedObject] {
            if fetchResults.count != 0 {
                var managedObject = fetchResults[0]
                numberCompleted = fetchResults.count
            } else {
                numberCompleted = 0
            }
        }
        return numberCompleted
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("GameData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("FatCat.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
        
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator

        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
//                    abort()
                
                }
            }
            
        }
        
    }


}

