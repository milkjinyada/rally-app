//
//  GameSettingCell.swift
//  
//
//  Created by Jinyada on 12/2/62.
//

import UIKit

class GameSettingCell: UITableViewCell {
    
    @IBOutlet weak var game: UILabel!
    @IBOutlet weak var gamenum: UILabel!
    @IBOutlet weak var choosegametext: UILabel!
    @IBAction func choosegamebtn(_ sender: Any) {
    //ChooseGameView.instance.showAlert()
    }
    @IBOutlet weak var gameimg: UIButton!
    @IBOutlet weak var gamename: UILabel!
    @IBOutlet weak var detailgame: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
