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


}

