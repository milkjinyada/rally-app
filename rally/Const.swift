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
