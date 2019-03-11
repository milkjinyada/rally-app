//
//  Agreegroup.swift
//  QR Code2
//
//  Created by Nisarat Mungjareon on 18/2/2562 BE.
//  Copyright © 2562 Nisarat Mungjareon. All rights reserved.
//

import Foundation
import UIKit

//===============กดเข้าร่วมกลุ่มแล้วเด้งไปอีกหน้าหนึ่ง===================//
class Agreegroup: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        launchApp()
    }
    
    
    func launchApp() {
        
        if presentedViewController != nil {

            return
        }

        let alert = UIAlertController(title: "Success", message: "Now you can join channel. Do you want to join channel" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Join Channel", style: .default, handler: { (nil) in

            //ถ้าเข้าร่วมกลุ่ม  ให้เด้งไปหน้า Nextpage
            //(withIdentifier: "next") ใส่ตรง StorybordID ของหน้าที่ต้องการให้เด้งไปนะจ๊ะ
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "next") as! Nextpage
            self.present(homeView, animated: true, completion: nil)
            
        }))

        present(alert, animated: true, completion: nil)
        

    }
   
}
