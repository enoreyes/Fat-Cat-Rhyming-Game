//
//  LevelTableViewCell.swift
//  FatCat
//
//  Created by Amy Reyes on 7/31/15.
//  Copyright (c) 2015 Mayan Robot. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    
    var levelNumber: Int?
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
