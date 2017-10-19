//
//  LevelCompletedVC.swift
//  FatCat
//
//  Created by Amy Reyes on 11/28/15.
//  Copyright © 2015 Mayan Robot. All rights reserved.
//

import UIKit
import Foundation
import Social

class LevelCompletedVC: UIViewController {
    
    var selectedLevel: Int?
    
    @IBOutlet weak var youCompleted: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        youCompleted.text = "You Completed Level \(selectedLevel!)!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "continueButton"){
            let stageSelectVC = segue.destinationViewController as! LevelSelectVC
        }
    }

    @IBAction func facebookButton(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.setInitialText("I just beat level \(selectedLevel!) on Fat Cat.! See if you can beat my score. http://www.appstore.com/fatcatrhyminggame")
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText("I just beat level \(selectedLevel!) on Fat Cat! See if you can beat my score. http://www.appstore.com/fatcatrhyminggame")
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func appStoreButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1039647698")!);
    }
    
}

