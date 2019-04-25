//
//  UserHomeViewController.swift
//  rally
//
//  Created by Jinyada on 11/3/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase

class UserHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    static var Channelname:String = "admintest"
    static var Username:String = ""
    var Gamename = [String]()
    //var Users:String = "admintest@gmaildotcom"
    var Mission:Int = 0
    var num = [Int]()

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var ChannelNamelb: UILabel!
    @IBOutlet weak var GroupNamelb: UILabel!
    @IBOutlet weak var Scorelb: UILabel!
    @IBOutlet weak var Timelb: UILabel!
    
    @IBAction func Logoutbtn(_ sender: Any) {
        Const().logOut()
        
        if (Auth.auth().currentUser == nil)
        {
            //ให้ ไปเริ่มที่หน้า  login
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! LoginViewController
            
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    func SetDetail() {
        ChannelNamelb.text = "ชื่อห้อง: \(UserHomeViewController.Channelname)"
    }
    
//ดึงข้อมูลจาก  Firebase
    var databaseRef:DatabaseReference!
    var MemberRef:DatabaseReference!
    var GameRef:DatabaseReference!
    private var _databaseHandle:DatabaseHandle! = nil //กำหนด  handle
    
    func databaseInit()
    {
        //ดึงข้อมูลของเจ้าของห้องนั่นๆ
        databaseRef = Database.database().reference().child("Channel").child(UserHomeViewController.Channelname)
        
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String:AnyObject]
            {
                //เอาค่าจาก firbase มาใส่ไว้ในตัวแปร
               
                var strSenderUser = ""
                if let strTemp = snapshot["User"] as? String
                {
                    strSenderUser = strTemp
                }
                else
                {
                    strSenderUser = ""
                }
                
               UserHomeViewController.Username = strSenderUser
               self.loadmission()
            
            }
        })
        
        databaseRef = Database.database().reference().child("Member").child(ViewController.userEmail!) //ดึง ref
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String:AnyObject]
            {
                //เอาค่าจาก firbase มาใส่ไว้ในตัวแปร
                var group = ""
                if let strTemp = snapshot["group"] as? String
                {
                    group = strTemp
                }
                else
                {
                    group = ""
                }
                
                //UserHomeViewController.Groupname = group
                self.GroupNamelb.text = "ชื่อกลุ่ม : \(group)"
                
            }
        })
        
    }
    
    func loadmission() {
        //เอาชื่อเจ้าของห้องไปดึงข้อมูลเกมของห้อง
        
        MemberRef = Database.database().reference().child("Member").child("\( UserHomeViewController.Username)/channeldata")
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
        
            GameRef = Database.database().reference().child("Member").child("\(UserHomeViewController.Username)/channeldata").child("game").child("\(i)")
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
                    
                    print(self.Gamename)
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                    
                }
            })
           
        }
    }
    
    //เวลาออกให้ เคลีย database handle ออกสะ
    func databaseRelease()
    {
        if (_databaseHandle != nil) //คือการการอินนิเชียวแล้ว เราก็จะไป release
        {
            self.databaseRef.child("Member").removeObserver(withHandle: _databaseHandle)
            _databaseHandle = nil 
        }
    }
    
    deinit {
        databaseRelease()
    }
    
    func Num() {
        
        for i in 1...Mission
        {
            num.append(i)
        }
        
    }
    
    
//แสดงผลข้อมูลเกม
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Gamename.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Usergame", for: indexPath) as! UserHomeTableViewCell
        
        let row = indexPath.row
        cell.gamename.text = Gamename[row]
        cell.gamenum.text = String(num[row])
    
        return cell
    }
    
    var valueToPass:String!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! UserHomeTableViewCell
        valueToPass = currentCell.gamename.text!
        
        switch valueToPass {
        case "เกมถามตอบ":
            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "questiongame") as! QuestionGameViewController
            self.present(GameVC, animated: true, completion: nil)
        case "เกมสลับภาพ":
            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "picscrollinggame") as! PicScrollingViewController
            self.present(GameVC, animated: true, completion: nil)
        case "เกมปาขวาน":
            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "ARHacheGame") as! ARHacheGameHomeViewController
            self.present(GameVC, animated: true, completion: nil)
        case "เกมเดินให้ดี":
            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "rungame") as! RunGameViewController
            self.present(GameVC, animated: true, completion: nil)
        case "เกมบวกเลข":
            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "mathgame") as! MathViewController
            self.present(GameVC, animated: true, completion: nil)
        default:
            print("error")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110.0;//Choose your custom row height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       databaseRelease()
       databaseInit()
       SetDetail()

    }
    
    


}
