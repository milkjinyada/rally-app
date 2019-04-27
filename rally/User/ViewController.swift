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
   
    static var UsernameUser:String! = "" //เก็บ Username ผู้ใช้
    static var userEmail:String! = "" //ไว้เก็บบัญชีผู้ใช้
    static var Groupname:String =  ""
    var status:Int!
    
//ดึงข้อมูลจาก firebase
    var databaseRef:DatabaseReference! //กำหนด ref
    private var _databaseHandle:DatabaseHandle! = nil //กำหนด  handle
    
    func databaseInit()
    {
        databaseRef = Database.database().reference().child("Member").child(ViewController.userEmail!) //ดึง ref
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
                
                self.UserName?.text = strSenderDisplayName
                ViewController.UsernameUser = strSenderDisplayName
               
                var strSenderStatus = 0
                if let strTemp = snapshot["status"] as? Int
                {
                    strSenderStatus = strTemp
                }
                else
                {
                    strSenderStatus = 0
                }
                
                self.status = Int(strSenderStatus)
                self.Checkstatus()
                
             
                    var group = ""
                    if let strTemp = snapshot["group"] as? String
                    {
                        group = strTemp
                    }
                    else
                    {
                        group = ""
                    }
                    
                    ViewController.Groupname = group
                    
            
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

            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserEmail()
       
        
        //เช็คว่ามีการ login ไหมถ้าไม่มีในไปเริ่มที่หน้า login ก่อน
        if (Auth.auth().currentUser == nil) //ไม่มีการ login
        {
            //ให้ ไปเริ่มที่หน้า  login
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! LoginViewController
            self.navigationController?.present(loginVC, animated: true, completion: nil) //แบบนี้จะไม่มีหน้า back กลับ
            
            print(Auth.auth().currentUser)
            
        }

    }
    
    //เช็คสถานะถ้าเป็น 0 คือเข้ามาครั้งแรกให้ไปที่หน้าแรก
    // แต่ถ้าสถานะเป็น 1 จะเข้าไปหน้าห้อง admin
    // สถานะ =  2 ไปหน้า MemberHome
    func Checkstatus()
    {
        print("สถานะคือ\(status!)")
        //ให้ไปหน้า admin
        if status! == 1{
            
            let AdminVC = self.storyboard?.instantiateViewController(withIdentifier: "admintabbar") as! TabbarViewController
            self.present(AdminVC, animated: true, completion: nil)
            
        }
            
        else if status! == 2{
            let MemberVc = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
            self.present(MemberVc, animated: true, completion: nil)
        }
            //ให้ไปหน้าแรก
        else
        {
            return
        }
        
    }
    

    func getUserEmail()
    {
        let AuthEmail = Auth.auth().currentUser?.email //ดึง email ที่ login  อยู่ปัจจุบัน
        if AuthEmail != nil //ต้องมีค่า
        {
            ViewController.userEmail = AuthEmail
            ViewController.userEmail = replaceSpacialCharacter(inputStr:ViewController.userEmail)
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
            CreateChannelView.username = ViewController.userEmail

        }
    }


}

