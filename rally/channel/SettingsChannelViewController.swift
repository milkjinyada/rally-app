//
//  SettingsChannelViewController.swift
//  rally
//
//  Created by Jinyada on 17/1/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase

class SettingsChannelViewController: UIViewController {
    
    var userEmail:String! = ""
    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
    var mission : String = ""
    var time : String = ""
    var group : String = ""
    var grouping : String = ""
    var roomname : String = ""

    @IBOutlet weak var channelname: UILabel!
    @IBOutlet weak var missionnum: UILabel!
    @IBOutlet weak var timenum: UILabel!
    @IBOutlet weak var groupnum: UILabel!
   
    @IBAction func MissionStp(_ sender: UIStepper) {
        missionnum.text = String(Int(sender.value))
        mission = String(Int(sender.value))
    }
    @IBAction func TimeStp(_ sender: UIStepper) {
        timenum.text = String(Int(sender.value))
        time = String(Int(sender.value))
    }
    @IBAction func GroupStp(_ sender: UIStepper) {
        groupnum.text = String(Int(sender.value))
        group = String(Int(sender.value))
    }
    
    @IBOutlet weak var groupingtxt: UILabel!
    @IBOutlet weak var groupingseg: UISegmentedControl!
    @IBAction func GroupingSegment(_ sender: UISegmentedControl) {
        
        switch groupingseg.selectedSegmentIndex
        {
        case 0:
            groupingtxt.text = "จับแบบ Random"
            grouping = "Random"
        case 1:
            groupingtxt.text = "จับแบบ Custom"
            grouping = "Custom"
        default:
            break
        }
    }

//เก็บ Rally Setting ขึ้น firebase
    @IBAction func SettingChannelbtn(_ sender: Any) {
        let SettingData: Dictionary<String,AnyObject> =
            [
                "ChannelName" : self.roomname as AnyObject,
                "Mission" : self.mission as AnyObject,
                "Time": self.time as AnyObject,
                "Group": self.group as AnyObject,
                "Grouping": self.grouping as AnyObject
        ]
        
        let SettingItemRef = self.MemberRef.child("\(self.userEmail!)/channeldata")
        SettingItemRef.setValue(SettingData)//ส่งขึ้น firebase 
    }
    
//ดึงข้อมูลชื่อ channel จาก firebase
    var databaseRef:DatabaseReference! //กำหนด ref
    private var _databaseHandle:DatabaseHandle! = nil //กำหนด  handle
    
    func databaseInit()
    {
        databaseRef = Database.database().reference().child("Member").child(userEmail!) //ดึง ref
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String:AnyObject]
            {
                //เอาค่าจาก firbase มาใส่ไว้ในตัวแปร
              
                var strSenderChannelName = ""
               
                if let strTemp = snapshot["channelname"] as? String
                {
                    strSenderChannelName = strTemp
                }
                else
                {
                    strSenderChannelName = ""
                }
                
                self.channelname.text = strSenderChannelName
                self.roomname = strSenderChannelName
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
    
    override func viewWillAppear(_ animated: Bool) {
        getUserEmail()
    }
    
    func getUserEmail()
    {
        let AuthEmail = Auth.auth().currentUser?.email //ดึง email ที่ login  อยู่ปัจจุบัน
        if AuthEmail != nil //ต้องมีค่า
        {
            userEmail = AuthEmail
            userEmail = replaceSpacialCharacter(inputStr:userEmail)
            
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
