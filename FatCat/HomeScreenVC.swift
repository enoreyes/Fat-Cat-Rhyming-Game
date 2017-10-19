//
//  ViewController.swift
//  FatCat
//
//  Created by Amy Reyes on 7/30/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {

    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
        defaults.setBool(false, forKey: "muted")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

