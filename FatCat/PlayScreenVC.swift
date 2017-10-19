//
//  PlayScreenVC.swift
//  FatCat
//
//  Created by Amy Reyes on 8/3/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import UIKit
import AVFoundation
import iAd

class PlayScreenVC: UIViewController, UITextFieldDelegate, ADBannerViewDelegate {

    @IBOutlet var colorBlock: UIView!
    @IBOutlet weak var textfieldColor: UITextField!
    @IBOutlet weak var hinkpink: UILabel!
    @IBOutlet weak var levelNumberLabel: UILabel!
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    
    var selectedStage: Int?
    var selectedColor: UIColor?
    var selectedQuestion: String?
    var selectedAnswer: String?
    var selectedHint: String?
    var audioPlayer = AVAudioPlayer()
    var selectedLevel: Int?
    var rhymeArray:Array<AnyObject> = []
    var bannerView: ADBannerView!
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorBlock.backgroundColor = selectedColor
        textfieldColor.textColor = selectedColor
        hinkpink.text = selectedQuestion
        levelNumberLabel.text = "\(selectedStage!)/20"
         self.textfieldColor.delegate = self
        
        
         textfieldColor.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        let masterDataUrl: NSURL = NSBundle.mainBundle().URLForResource("Level\(self.selectedLevel!)JSON", withExtension: "json")!
        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl)!
        let jsonResult:AnyObject! = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
        rhymeArray = jsonResult as! Array
        
        // ADS
        
        bannerView = ADBannerView(adType: .Banner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.delegate = self
        bannerView.hidden = true
        view.addSubview(bannerView)
        
        let viewsDictionary = ["bannerView": bannerView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
    }
    
    
    // ADS
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView.hidden = false
        print("worked")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        bannerView.hidden = true
        print("failed")
    }
    
    //CONTINUE

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidChange(textField: UITextField) -> Bool {
        
        var correctAnswer = selectedAnswer?.lowercaseString
        var correctSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("correctDing", ofType: "mp3")!)
        var levelCompleteSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("levelcomplete", ofType: "wav")!)
        let currentNumberCompleted = appDel.completedInLevel(self.selectedLevel!)
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if self.textfieldColor.text == "\(correctAnswer!)" {
            self.view.endEditing(true)
            textfieldColor.textColor = Constants.FCColors.kFCDefault
            
            var error:NSError?
            
            do {
                
                if currentNumberCompleted == 19 {
                audioPlayer = try AVAudioPlayer(contentsOfURL: levelCompleteSound)
                } else {
                audioPlayer = try AVAudioPlayer(contentsOfURL: correctSound)
                }
                
            } catch var error1 as NSError {
                error = error1
            }
            
            
            
            if (defaults.boolForKey("muted")) == false {
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } else {
                print("Muted!")
            }
            
            delay(0.85) {
                
                if currentNumberCompleted == 19 {
                    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                    appDel.markCompleted(self.selectedLevel!, item: self.selectedStage!)
                    self.performSegueWithIdentifier("levelComplete", sender: nil)
                } else if self.selectedStage < self.rhymeArray.count {

                self.appDel.markCompleted(self.selectedLevel!, item: self.selectedStage!)

                self.textfieldColor.text = ""

                    
                self.writeNewLevelNum()
                self.levelNumberLabel.text = "\(self.selectedStage!)/20"
                    
                var levelNumDict: AnyObject = self.rhymeArray[self.selectedStage! - 1]
                    
                var levelQuestion: AnyObject = levelNumDict["question"] as AnyObject!!
                    
                var levelAnswer: AnyObject = levelNumDict["answer"] as AnyObject!!
                var levelHint: AnyObject = levelNumDict["hint"] as AnyObject!!
                    
                self.hinkpink.text = "\(levelQuestion)"
                self.selectedAnswer = "\(levelAnswer)"
                self.textfieldColor.textColor = self.selectedColor
                self.selectedHint = levelHint as! String
                    
                    
                } else {
                        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                        appDel.markCompleted(self.selectedLevel!, item: self.selectedStage!)
                        self.performSegueWithIdentifier("unwindBack", sender: nil)
                    }
            }
            return false
        } else {
            return false
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
    }
    
    func writeNewLevelNum() -> Int {
        self.selectedStage!++
        return self.selectedStage!
    }
    

    
    @IBAction func hintButton() {
        
            self.performSegueWithIdentifier("showHint", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showHint") {
            
            let hintScreenVC = segue.destinationViewController as! HintScreenVC
            hintScreenVC.selectedHint = selectedHint
        }
        
        else if (segue.identifier! == "levelComplete") {
            let levelCompletedVC = segue.destinationViewController as! LevelCompletedVC
            levelCompletedVC.selectedLevel = selectedLevel
        }
    }
}
