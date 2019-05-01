//
//  UserHomeTableViewCell.swift
//  rally
//
//  Created by Jinyada on 6/4/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit

class UserHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var gamenum: UILabel!
    @IBOutlet weak var gamename: UILabel!
    @IBOutlet weak var gameimg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
