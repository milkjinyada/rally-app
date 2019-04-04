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
        NextgameAR()
    }
    
    var realscore : Int = 0 //คะแนนที่เกิดจากการตัดให้เต็ม 10 คะแนน
    //เล่นเกมเสร็จขึ้นแจ้งเตือนให้กลับไปหน้าสแกนเริ่มเกมต่อไป
    func NextgameAR() {
        
        //รับค่าคะแนนจากหน้าวิวคอนโทรเล่อ
        let defaults = UserDefaults.standard
        let GameS = defaults.value(forKey: "score")
        let score = GameS as! Int //รับค่าคะแนนในเกมมาจากหน้า viewcontroller
        
        //let S = GameS as! Int!
        
        //เอาคะแนนในเกมมาคิด ทุกๆ 10 คะแนน= 1 คะแนน
        if (score > 0 && score <= 9) {
            realscore = 0
        }
        else if (score >= 10 && score <= 19) {
            realscore = 1
        }
        else if (score >= 20 && score <= 29) {
            realscore = 2
        }
        else if (score >= 30 && score <= 39) {
            realscore = 3
        }
        else if (score >= 40 && score <= 49) {
            realscore = 4
        }
        else if (score >= 50 && score <= 59) {
            realscore = 5
        }
        else if (score >= 60 && score <= 69) {
            realscore = 6
        }
        else if (score >= 70 && score <= 79) {
            realscore = 7
        }
        else if (score >= 80 && score <= 89) {
            realscore = 8
        }
        else if (score >= 90 && score <= 100) {
            realscore = 9
        }
        else {
            realscore = 10
        }
        
        let alert = UIAlertController(title: "Success", message: "You got score = \(String(score)) คะแนน (ทุก 10 คะแนนคิดเป็น 1 คะแนน) = \(realscore) คะแนน" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (nil) in
            
            
            //เมื่อกดปุ่มเอลิทจะเอาคะแนนที่ถูกหารแล้วเข้า firebase
            let Name_ = self.realscore
            let post : [String: AnyObject] = ["Score" : Name_ as AnyObject]
            let databaseRef = Database.database().reference()
            databaseRef.child("ARScore").childByAutoId().setValue(post) //หัวข้อชื่อ Posts
            
            
            //ถ้าเข้าร่วมกลุ่ม  ให้เด้งไปหน้า Nextpage
            //(withIdentifier: "next") ใส่ตรง StorybordID ของหน้าที่ต้องการให้เด้งไปนะจ๊ะ
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "userhomeview") as! UserHomeViewController
            self.present(homeView, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
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
