//
//  TableViewCellScore.swift
//  RankingScore
//
//  Created by Kievy on 11/4/2562 BE.
//  Copyright © 2562 Kievy. All rights reserved.
//

import UIKit
import Firebase

class TableViewCellScore: UITableViewCell {
    
    @IBOutlet var NumberFourtoN: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    var  RankScore: RankScoree?{
        
        didSet{
            
            nameLabel.text =  RankScore?.Groupname
            scoreLabel.text = String(describing: RankScore!.gameSum)
        }
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
