//
//  UserHomeViewController.swift
//  rally
//
//  Created by Jinyada on 11/3/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController {

    @IBOutlet weak var ChannelNamelb: UILabel!
    @IBOutlet weak var GroupNamelb: UILabel!
    @IBOutlet weak var Scorelb: UILabel!
    @IBOutlet weak var Timelb: UILabel!
    
    @IBAction func Logoutbtn(_ sender: Any) {
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
