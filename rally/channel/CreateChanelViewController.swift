//
//  CreateChanelViewController.swift
//  rally
//
//  Created by Jinyada on 9/1/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase

class CreateChanelViewController: UIViewController {

    var ChannelRef : DatabaseReference! = Database.database().reference(withPath: "Channel")
    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")

    
//หน้าตั้งชื่อห้อง
    var username : String = ""
    var namecheck : Bool = false
    @IBOutlet weak var lbChannelName: UILabel!
    @IBOutlet weak var ChannelName: UITextField!
    

    @IBAction func CreateChannelbtn(_ sender: Any) {
        
        var channelName = self.ChannelName.text
        var status : Int = 0
       
        if ChannelName.text!.characters.count == 0
        {
            lbChannelName.text = "กรุณากรอกชื่อผู้ใช้"
            ChannelName.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
            return
        }
        else
        {
            self.ChannelRef.observe(.value, with: { (snapshot) in
                for snap in snapshot.children {
                    var snapname = (snap as! DataSnapshot).key
                    if snapname == channelName as! String
                    {
                        self.lbChannelName.text = "ชื่อห้องนี้มีผู้ใช้แล้ว"
                        self.ChannelName.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
                        return
                    }
                    
                }
                self.lbChannelName.text = "ใช้ชื่อนี้ได้"
                self.ChannelName.backgroundColor = UIColor.white

                
            //ถ้าชื่อห้องไม่ซ้ำ เก็บชื่อห้องไปยัง DB
                            
                let MemberItemRef = self.MemberRef.child("\(self.username)/channelname")
                MemberItemRef.setValue(channelName)//ส่งขึ้น firebase
                
            //เปลื่ยน status user
                let StatusItemRef = self.MemberRef.child("\(self.username)/status")
                StatusItemRef.setValue(1)//ส่งขึ้น firebase
                
                let Settingchannel = self.storyboard?.instantiateViewController(withIdentifier: "settingschannel") as! SettingsChannelViewController
                
                self.navigationController?.present(Settingchannel, animated: true, completion: nil) //แบบนี้จะไม่มีหน้า back กลับ

                return
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    



}
