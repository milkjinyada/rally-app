//
//  HomeViewController.swift
//  AR Madness
//
//  Created by O'Sullivan, Andy on 30/05/2018.
//  Copyright © 2018 O'Sullivan, Andy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let gameScore = defaults.value(forKey: "score"){
            let score = gameScore as! Int
            scoreLabel.text = "Score: \(String(score))"
            
            
            //เอาคะแนนเข้า firebase
            let Name_ = score
            let post : [String: AnyObject] = ["Score" : Name_ as AnyObject]
            let databaseRef = Database.database().reference()
            databaseRef.child("ARScore").childByAutoId().setValue(post) //หัวข้อชื่อ Posts
        }
    }
    
    @IBAction func onPlayButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToGameSegue", sender: self)
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
