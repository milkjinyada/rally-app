//
//  Const.swift
//  holphak
//
//  Created by jinyada on 6/3/60.
//  Copyright © พ.ศ. 2560 jinyada. All rights reserved.

//ฟังก์ชั่นที่เขียนขึ้นมาไว้เรียกใช้

import Foundation
import UIKit
import Firebase

class Const
{
    //Alert
    func ShowAlert(title:String,message:String,viewContronller:UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let resultAlert = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(resultAlert)
        viewContronller.present(alert, animated: true, completion: nil)
    }
    
    //ดึงวันที่
    func CurrenDateTimeToStr() -> String
    {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: currentDate)
        
    }
    //ออกจากระบบ
    func logOut()
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    }
    
    
}

class member{
    
    var name: String!
    var email: String!
    var status: Int = 0
    var join: String!
    var sex:String!
    let group: String!
   
    var conpleted: Bool!
    let ref: DatabaseReference!
    init(name: String, email: String, status:Int, join: String, sex:String, group:String) {
        self.group = group
        self.name = name
        self.email = email
        self.status = status
        self.join = join
        self.sex = sex
        
        self.ref = nil
    }
    //ไว้ใช้เวลาอยากจะเรียกข้อมูลจาก firebase มาโชว์ว่าอยากจะโชว์อะไรบ้าง
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        email = snapshotValue["email"] as! String
        status = snapshotValue["status"] as! Int
        join = snapshotValue["join"] as! String
        sex = snapshotValue["sex"] as! String
        group = snapshotValue["group"] as! String
        ref = snapshot.ref
        
    }
    //อยากจะเอาข้อมูลอะไรไปเก็บใน firebase ก็ใช้ตัวนี้
    func toAnyObject() -> Any {
        return [
            "name": name,
            "email": email,
            "status": status,
            "join": join,
            "sex": sex,
            "group": group
        ]
    }
}
