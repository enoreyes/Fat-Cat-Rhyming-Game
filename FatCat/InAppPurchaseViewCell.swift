//
//  InAppPurchaseViewCell.swift
//  FatCat
//
//  Created by Amy Reyes on 9/29/15.
//  Copyright © 2015 Mayan Robot. All rights reserved.
//

import UIKit

class InAppPurchaseViewCell: UITableViewCell {

    
    @IBOutlet weak var productLabel: UILabel!
    
    @IBAction func buyButton(sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
