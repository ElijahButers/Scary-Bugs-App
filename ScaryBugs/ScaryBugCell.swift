//
//  ScaryBugCell.swift
//  ScaryBugs
//
//  Created by User on 8/15/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

class ScaryBugCell: UITableViewCell {
    
    @IBOutlet weak var bugImageView: UIImageView!
    @IBOutlet weak var bugNameLabel: UILabel!
    @IBOutlet weak var howScaryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
