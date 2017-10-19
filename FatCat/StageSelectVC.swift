//
//  StageSelectVC.swift
//  FatCat
//
//  Created by Amy Reyes on 7/31/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import UIKit
import CoreData

class StageSelectVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var stageCollectionView: UICollectionView!
    @IBOutlet weak var backButtonImg: UIButton!
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    
    var selectedLevel: Int?
    var rhymeArray:Array<AnyObject> = []
    let levelColors = ["1":Constants.FCColors.kFCRed, "2":Constants.FCColors.kFCLightBlue, "3":Constants.FCColors.kFCGreen, "4":Constants.FCColors.kFCYellow, "5":Constants.FCColors.kFCDarkBlue, "6":Constants.FCColors.kFCGrey, "7":Constants.FCColors.kFCPurple, "8":Constants.FCColors.kFCLightRed]
    
    let backColors = ["1": "Red", "2": "LightBlue", "3": "Green", "4": "Yellow", "5": "DarkBlue", "6": "Grey", "7": "Purple", "8": "LightRed"]
    let reuseIdentifier = "stageCell"
    var appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting Colors for Level
        
        levelLabel.text = "Level \(selectedLevel!)"
        levelLabel.textColor = levelColors["\(selectedLevel!)"]
        let backimageColor = backColors["\(selectedLevel!)"]
        let image = UIImage(named: "backButton\(backimageColor!).png") as UIImage!
        backButtonImg.setImage(image, forState: UIControlState.Normal)
        
        let masterDataUrl: NSURL = NSBundle.mainBundle().URLForResource("Level\(self.selectedLevel!)JSON", withExtension: "json")!
        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl)!
        let jsonResult:AnyObject! = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
        rhymeArray = jsonResult as! Array
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
            return 1
    }

    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            // Pulling JSON
            return rhymeArray.count
    }
    
    override func viewWillAppear(animated: Bool) {
        stageCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,
            forIndexPath: indexPath) as! StageSelectViewCell

            
            // Configure the cell
            cell.backgroundColor = levelColors["\(selectedLevel!)"]
            let levelNumDict: AnyObject = rhymeArray[indexPath.row]
            let levelNum: AnyObject = levelNumDict["item"] as AnyObject!!
            cell.levelNumber.text = "\(levelNum)"
            
            // let currentLevelCompletedArray = appDel.completedArray["\(selectedLevel!)"]
            
            var context: NSManagedObjectContext = appDel.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "GameData")
            fetchRequest.predicate = NSPredicate(format: "level = %@ && item = %@", selectedLevel! as NSNumber, levelNum as! NSNumber)
            if let fetchResults = (try? appDel.managedObjectContext!.executeFetchRequest(fetchRequest)) as? [GameData] {
                if fetchResults.count != 0 {
                    let cellIsCompleted = fetchResults[0].completed as Bool
                    
                    if cellIsCompleted == true {
                        cell.completedCircle.hidden = false
                        print("d")
                    } else if cellIsCompleted == false{
                        cell.completedCircle.hidden = true
                        print("a")
                    } else {
                        cell.completedCircle.hidden = false
                        print("k")
                    }
                }
            }

            return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showGame") {
            let rowSelected = sender as! StageSelectViewCell
            let levelSelected = rowSelected.levelNumber
            if let indexPath = stageCollectionView.indexPathForCell(sender as! UICollectionViewCell) {
                let playScreenVC = segue.destinationViewController as! PlayScreenVC
                let levelNumDict: AnyObject = rhymeArray[indexPath.row]
                
                let levelNum: AnyObject = levelNumDict["item"] as AnyObject!!
                let levelQuestion: AnyObject = levelNumDict["question"] as AnyObject!!
                let levelAnswer: AnyObject = levelNumDict["answer"] as AnyObject!!
                let levelHint: AnyObject = levelNumDict["hint"] as AnyObject!!
                let levelNumString = "\(levelNum)"
                let levelNumReal = Int(levelNumString)
                let level = selectedLevel
                
                playScreenVC.selectedStage = levelNumReal
                playScreenVC.selectedColor = levelColors["\(selectedLevel!)"]!
                playScreenVC.selectedQuestion = levelQuestion as! String
                playScreenVC.selectedAnswer = levelAnswer as! String
                playScreenVC.selectedHint = levelHint as! String
                playScreenVC.selectedLevel = level 
            }
        }
    }

    
}



