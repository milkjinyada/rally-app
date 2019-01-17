//
//  tbMemberCell.swift
//  rally
//
//  Created by Jinyada on 17/1/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit

class tbMemberCell: UITableViewCell {

    @IBOutlet weak var membernum: UILabel!
    @IBOutlet weak var memberusername: UILabel!
    @IBOutlet weak var membergroup: UILabel!
    @IBOutlet weak var membersex: UIImageView!
    @IBOutlet weak var memberstatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
