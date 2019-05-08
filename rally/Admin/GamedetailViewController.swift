//
//  GamedetailViewController.swift
//  rally
//
//  Created by Jinyada on 8/5/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit

class GamedetailViewController: UIViewController {

    @IBOutlet weak var gamename: UILabel!
    @IBOutlet weak var gameqr: UIImageView!
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    var game:String = GamelistViewController.valueToPass
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch game {
        case "เกมถามตอบ":
           gamename.text = game
           gameqr.image = UIImage(named: "question")
          
        case "เกมสลับภาพ":
            gamename.text = game
            gameqr.image = UIImage(named: "pic")
           
        case "เกมปาขวาน":
            gamename.text = game
            gameqr.image = UIImage(named: "AR")
          
        case "เกมเดินให้ดี":
            gamename.text = game
            gameqr.image = UIImage(named: "run")
           
        case "เกมบวกเลข":
            gamename.text = game
            gameqr.image = UIImage(named: "math")
           
        default:
            print("error")
        }
    }
    

}
