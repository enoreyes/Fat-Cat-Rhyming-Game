//
//  LevelSelectVC.swift
//  FatCat
//
//  Created by Amy Reyes on 7/31/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import UIKit

class LevelSelectVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "levelCell"
    let levels = [1,2,3,4,5,6,7,8]
    let levelColors = ["1":Constants.FCColors.kFCRed, "2":Constants.FCColors.kFCLightBlue, "3":Constants.FCColors.kFCGreen, "4":Constants.FCColors.kFCYellow, "5":Constants.FCColors.kFCDarkBlue, "6":Constants.FCColors.kFCGrey, "7":Constants.FCColors.kFCPurple, "8":Constants.FCColors.kFCLightRed]

    @IBOutlet weak var mutedImage: UIButton!
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Muted Button
    
    @IBAction func muteButton() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var switcher = defaults.boolForKey("muted")
        
        defaults.setBool(!switcher, forKey: "muted")
        
        var audiostatus = "audiounmuted"
        
        if (defaults.boolForKey("muted")) == true {
            audiostatus = "audiomuted.png"
        } else {
            audiostatus = "audiounmuted.png"
        }
        
        mutedImage.setImage(UIImage(named: audiostatus), forState: .Normal)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    // }
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LevelTableViewCell
        let row = indexPath.row
        
        cell.levelNumber = self.levels[indexPath.row]
        
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let currentNumberCompleted = appDel.completedInLevel(cell.levelNumber!)
        let previousNumberCompleted = appDel.completedInLevel(cell.levelNumber! - 1)
        
        if cell.levelNumber >= 2 {
            if previousNumberCompleted >= 18 {
                cell.levelLabel.text = "Level \(cell.levelNumber!)"
                cell.userInteractionEnabled = true
            } else {
                cell.levelLabel.text = "Locked"
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = false
            }
        } else {
            cell.levelLabel.text = "Level \(cell.levelNumber!)"
        }
        
        // var levelName = cell.viewWithTag(10) as! UILabel
        // let levelNumber = self.levels[indexPath.row]
        // levelName.text = "Level \(levelNumber)"
        
        // levelColors["1"] as! UIColor
        
        cell.backgroundColor = levelColors["\(cell.levelNumber!)"]
        
        let numberCompleted = cell.viewWithTag(20) as! UILabel
    
        numberCompleted.text = "\(currentNumberCompleted)/20"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showStages") {
            let rowSelected = sender as! LevelTableViewCell
            let levelSelected = rowSelected.levelNumber
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                let stageSelectVC = segue.destinationViewController as! StageSelectVC
                stageSelectVC.selectedLevel = levelSelected
            }
        }
    }
    
    // MARK: - Table View Delegates
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1)
        cell?.selectedBackgroundView = highlightView
    }
    
}

