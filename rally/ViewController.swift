//
//  ViewController.swift
//  rally
//
//  Created by Jinyada on 3/1/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
 
    @IBOutlet weak var UserName: UILabel!
   
    var userEmail:String! = "" //ไว้เก็บบัญชีผู้ใช้
    
//ดึงข้อมูลจาก firebase
    var databaseRef:DatabaseReference! //กำหนด ref
    private var _databaseHandle:DatabaseHandle! = nil //กำหนด  handle
    
    func databaseInit()
    {
        databaseRef = Database.database().reference().child("Member").child(userEmail!) //ดึง ref
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
                
                self.UserName.text = strSenderDisplayName
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
    
//ฟังก์ชั่น logout
    @IBAction func logout(_ sender: Any) {
        Const().logOut()
        
        if (Auth.auth().currentUser == nil)
        {
            //ให้ ไปเริ่มที่หน้า  login
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! LoginViewController
            
            self.navigationController?.present(loginVC, animated: true, completion: nil) //แบบนี้จะไม่มีหน้า back
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //เช็คว่ามีการ login ไหมถ้าไม่มีในไปเริ่มที่หน้า login ก่อน
        if (Auth.auth().currentUser == nil) //ไม่มีการ login
        {
            //ให้ ไปเริ่มที่หน้า  login
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! LoginViewController
            self.navigationController?.present(loginVC, animated: true, completion: nil) //แบบนี้จะไม่มีหน้า back กลับ
            
            print(Auth.auth().currentUser)
            
        }
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
    
//ส่งข้อมูลผ่านสาย segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //ส่งอีเมล User ไป
        if segue.identifier == "passuser" {
            let CreateChannelView = segue.destination as! CreateChanelViewController
            CreateChannelView.username = userEmail
        }
    }


}

