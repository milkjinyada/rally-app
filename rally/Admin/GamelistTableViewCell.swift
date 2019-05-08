//
//  GamelistTableViewCell.swift
//  rally
//
//  Created by Jinyada on 8/5/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit

class GamelistTableViewCell: UITableViewCell {
    @IBOutlet weak var gamenum: UILabel!
    @IBOutlet weak var gamename: UILabel!
    @IBAction func gamebtn(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
