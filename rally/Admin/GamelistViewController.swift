//
//  GamelistViewController.swift
//  rally
//
//  Created by Jinyada on 8/5/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase

class GamelistViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var Gamename = [String]()
    var num = [Int]()
    var Mission:Int = 0
    var MemberRef:DatabaseReference!
    var GameRef:DatabaseReference!
    private var _databaseHandle:DatabaseHandle! = nil //กำหนด  handle
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Gamename.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gamelist", for: indexPath) as! GamelistTableViewCell
        let row = indexPath.row
        cell.gamename.text = Gamename[row]
        cell.gamenum.text = String(num[row])

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0;//Choose your custom row height
    }
    
    static var valueToPass:String!

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! GamelistTableViewCell
        GamelistViewController.valueToPass = currentCell.gamename.text!
        
        let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "gamedetail") as! GamedetailViewController
        self.present(GameVC, animated: true, completion: nil)
        
        
    }
    
    
    func loadmission() {
        //เอาชื่อเจ้าของห้องไปดึงข้อมูลเกมของห้อง
        print(AdminHomeViewController.userEmail)
        MemberRef = Database.database().reference().child("Member").child("\(AdminHomeViewController.userEmail!)/channeldata")
        MemberRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String:AnyObject]
            {
                //เอาค่าจาก firbase มาใส่ไว้ในตัวแปร
                var strSenderMission = ""
                if let strTemp = snapshot["Mission"] as? String
                {
                    strSenderMission = strTemp
                }
                else
                {
                    strSenderMission = ""
                }
                
                self.Mission = Int(strSenderMission)!
                self.loadgame()
                
            }
        })
    }
    
    func loadgame(){
        //ดึงข้อมูลเกมตามจำนวนเกมของห้องนั้นๆ
        Num()
        for i in 0...self.Mission-1{
            
            GameRef = Database.database().reference().child("Member").child("\(AdminHomeViewController.userEmail!)/channeldata").child("game").child("\(i)")
            GameRef.observe(.value, with: { (snapshot) in
                
                if let snapshot = snapshot.value as? [String:AnyObject]
                {
                    var strSenderGame = ""
                    if let strTemp = snapshot["gamename"] as? String
                    {
                        strSenderGame = strTemp
                    }
                    else
                    {
                        strSenderGame = ""
                    }
                    //เก็บรายชื่อเกมเข้า array
                    self.Gamename.append(strSenderGame)
                    //self.Gamename[i] = strSenderGame
                    
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                    
                }
            })
        }
    }
    
    func Num() {
        
        for i in 1...Mission
        {
            num.append(i)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadmission()
        
    }


}
