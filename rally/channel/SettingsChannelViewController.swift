//
//  SettingsChannelViewController.swift
//  rally
//
//  Created by Jinyada on 17/1/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit

class SettingsChannelViewController: UIViewController {

    @IBOutlet weak var missionnum: UILabel!
    @IBOutlet weak var groupnum: UILabel!
   
    @IBAction func MissionStp(_ sender: UIStepper) {
        missionnum.text = String(Int(sender.value))
    }
    @IBAction func GroupStp(_ sender: UIStepper) {
        groupnum.text = String(Int(sender.value))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
