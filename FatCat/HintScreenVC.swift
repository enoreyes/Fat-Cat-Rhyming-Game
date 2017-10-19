//
//  HintScreenVC.swift
//  FatCat
//
//  Created by Amy Reyes on 8/5/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import UIKit
import Foundation
import StoreKit


class HintScreenVC: UIViewController {

    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var continueHide: UIButton!
    @IBOutlet weak var cancelMove: UIButton!
    @IBOutlet weak var buyMoreHidden: UIButton!
    
    var selectedHint: String?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let numberOfHints: Int? = defaults.valueForKey(Constants.userConstants.numberOfHints) as! Int
        hintLabel.text = "You have \(numberOfHints!) hints left."
        buyMoreHidden.hidden = true
//        self.fetchAvailableProducts()
        
        
        if numberOfHints <= 0 {
            self.continueHide.hidden = true
            self.buyMoreHidden.hidden = false

        }
        
    }
    
    @IBAction func continueButton() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let numberOfHints: Int? = defaults.valueForKey(Constants.userConstants.numberOfHints) as! Int
        if numberOfHints > 0 {
            let tempNumberOfHints = (numberOfHints!-1)
            defaults.setValue(tempNumberOfHints, forKey: Constants.userConstants.numberOfHints)
            self.hintLabel.text = "\(selectedHint!)"
            self.cancelMove.frame = CGRectMake(95, 250, 110, 42)
            self.continueHide.hidden = true
        }
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

}
