//
//  AdminHomeViewController.swift
//  rally
//
//  Created by Jinyada on 17/1/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase

class AdminHomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    static var ChannelName:String = "" //ชื่อห้อง
    static var userEmail:String! = "" //อีเมลเจ้าของห้อง
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var channelname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var missionnum: UILabel!
    @IBOutlet weak var groupnum: UILabel!
    @IBOutlet weak var timepermission: UILabel!
    @IBOutlet weak var starttimebtn: UIButton!
    var GameTime:Int = 0
    var cnt:Int=1
    @IBOutlet weak var Timerlb: UILabel!
   
    //จับเวลาเล่นเกมจากเวลาที่ admin ใส่
    @IBAction func StartTimeBtn(_ sender: UIButton) {
        cnt+=1
        if cnt%2==0{
            sender.setImage(UIImage(named: "Timebtn"), for: .normal)
            TimerManager.start(withSeconds: Int(GameTime*60))
            TimerManager.timeString = { time, ends in
                if ends == false {
                    self.Timerlb.text = time
                }
                else {
                    // Perform here the task you want to do after timer finishes.
                }
            }
        }else{
            sender.setImage(UIImage(named: "startbtn"), for: .normal)
        }
    }
    
    @IBAction func settingchannelbtn(_ sender: Any) {
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "settingschannel") as! SettingsChannelViewController
        self.present(homeView, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        Const().logOut()
        if (Auth.auth().currentUser == nil)
        {
            //ให้ ไปเริ่มที่หน้า  login
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! LoginViewController
            
            self.navigationController?.present(loginVC, animated: true, completion: nil) //แบบนี้จะไม่มีหน้า back
        }
    }
    
    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
    var users = [User]()
    var num = [Int]()
   

    
//ดึงข้อมูล Chanel จาก firebase
    
    //กำหนด ref
    var databaseRef:DatabaseReference!
    var channeldataRef:DatabaseReference!
    private var _databaseHandle:DatabaseHandle! = nil //กำหนด  handle
    
    func databaseInit()
    {
        databaseRef = Database.database().reference().child("Member").child(AdminHomeViewController.userEmail!)
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String:AnyObject]
            {
                //เอาค่าจาก firbase มาใส่ไว้ในตัวแปร
                var strSenderDisplayName = ""
                if let strTemp = snapshot["name"] as? String
                {
                    strSenderDisplayName = strTemp
                }
                else
                {
                    strSenderDisplayName = ""
                }
               
                var strSenderChannelName = ""
                if let strTemp = snapshot["channelname"] as? String
                {
                    strSenderChannelName = strTemp
                }
                else
                {
                    strSenderChannelName = ""
                }
                
                self.username.text = strSenderDisplayName
                self.channelname.text = strSenderChannelName
                AdminHomeViewController.ChannelName = strSenderChannelName
            }
        })
        
        channeldataRef = Database.database().reference().child("Member").child("\(AdminHomeViewController.userEmail!)/channeldata")
        channeldataRef.observe(DataEventType.value, with: { (snapshot) in
            
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
                
                var strSenderTime = ""
                if let strTemp = snapshot["Time"] as? String
                {
                    strSenderTime = strTemp
                }
                else
                {
                    strSenderTime = ""
                }
                var strSenderGroup = ""
                if let strTemp = snapshot["Group"] as? String
                {
                    strSenderGroup = strTemp
                }
                else
                {
                    strSenderGroup = ""
                }
                
                self.missionnum.text = strSenderMission
                self.groupnum.text = strSenderGroup
                self.timepermission.text = strSenderTime
                self.GameTime = Int(strSenderTime) ?? 0
                
            }
        })
        
        
    }
    
    //เวลาออกให้ เคลีย database handle ออกสะ
    func databaseRelease()
    {
        if (_databaseHandle != nil) //คือการการอินนิเชียวแล้ว เราก็จะไป release
        {
            self.databaseRef.child("Member").removeObserver(withHandle: _databaseHandle)
            _databaseHandle = nil //จะได้รู้ว่าตอนนี้ยังไม่ init
        }
    }
    
    deinit {
        databaseRelease()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membercell", for: indexPath) as! tbMemberCell
        
        let user = users[indexPath.row]
        let row = indexPath.row
        cell.membernum.text = String(num[row])
        cell.memberusername.text = user.name
        cell.membergroup.text = user.group
        cell.membersex.image = UIImage(named: user.sex!)
        cell.memberstatus.image = UIImage(named: user.join!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 68.0;//Choose your custom row height
    }
    
//ดึงข้อมูล Member มาใส่ใน tableview
    func fetchUser() {
            MemberRef.observe(DataEventType.value, with: {(snapshot) in
            self.users.removeAll()
                if let snapShort = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapShort{
                        if let dictionary = snap.value as? [String: AnyObject]{
                        let user = User()
                            user.name = dictionary["name"] as? String
                            user.group = dictionary["group"] as? String
                            user.sex = dictionary["sex"] as? String
                            user.join = dictionary["join"] as? String
                            user.status = dictionary["status"] as? Int
                            user.Channel = dictionary["Channel"] as? String
                            
                            //เช็คว่า member ไหนเป็น สมาชิกของห้องนี้บ้าง ถึงค่อยเพิ่มชื่อเข้าไปใน tb
                            if user.Channel == (AdminHomeViewController.ChannelName) {
                                self.users.append(user)
                               
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.num.removeAll()
                        self.Num()
                        self.tableview.reloadData()
                    }
                }
            })
    }
    
    func Num() {
    
        for i in 1...users.count
        {
            num.append(i)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserEmail()
        fetchUser()
    }
    
    func getUserEmail()
    {
        let AuthEmail = Auth.auth().currentUser?.email //ดึง email ที่ login  อยู่ปัจจุบัน
        if AuthEmail != nil //ต้องมีค่า
        {
            AdminHomeViewController.userEmail = AuthEmail
            AdminHomeViewController.userEmail = replaceSpacialCharacter(inputStr:AdminHomeViewController.userEmail)
            
            databaseRelease() //ให้มันเคลียค่าทิ้งสะก่อน
            databaseInit()
        }
    }
    
    
    func replaceSpacialCharacter(inputStr:String) -> String{
        var outputStr = inputStr
        
        outputStr = outputStr.replacingOccurrences(of: ".", with: "dot")
        outputStr = outputStr.replacingOccurrences(of: "#", with: "sharp")
        outputStr = outputStr.replacingOccurrences(of: "$", with: "dollar")
        outputStr = outputStr.replacingOccurrences(of: "[", with: "stasign")
        outputStr = outputStr.replacingOccurrences(of: "}", with: "endsign")
        
        return outputStr
    }
}

