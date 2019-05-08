//
//  ARHacheGameView.swift
//  rally
//
//  Created by Jinyada on 8/5/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit

class ARHacheGameView: UIViewController {
    static var isjoingame:Bool = false
    
    @IBAction func startgamebtn(_ sender: Any) {
        ARHacheGameView.isjoingame = true
    }
    
    @IBAction func backbtn(_ sender: Any) {
        let MemberVc = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
        self.present(MemberVc, animated: true, completion: nil)
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
