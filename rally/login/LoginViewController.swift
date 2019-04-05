//
//  LoginViewController.swift
//  holphak
//
//  Created by jinyada on 6/3/60.
//  Copyright © พ.ศ. 2560 jinyada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate {
    

    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBAction func btnLogin(_ sender: Any)
    {
        if txtEmail.text!.characters.count<6
        {
            lbStatus.text = "อีเมลไม่ถูกต้อง"
            txtEmail.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
            Const().ShowAlert(title: "Error", message: "อีเมลไม่ถูกต้อง", viewContronller: self)
            return
        }
        else
        {
            txtEmail.backgroundColor = UIColor.white
            lbStatus.text=""
        }
        
        if txtPassword.text!.characters.count<6
        {
            lbStatus.text = "รหัสผ่านไม่ถูกต้อง"
            txtPassword.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
            Const().ShowAlert(title: "Error", message: "รหัสผ่านไม่ถูกต้อง", viewContronller: self)
            return
        }
        else
        {
            txtPassword.backgroundColor = UIColor.white
            lbStatus.text=""
        }

        
        let email = txtEmail.text
        let password = txtPassword.text
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (firebaseUser, firebaseError) in
        if let error = firebaseError
        {
            self.lbStatus.text=error.localizedDescription
            Const().ShowAlert(title: "Error", message: error.localizedDescription, viewContronller: self)
            return
        }
        else
        {
            self.lbStatus.text="Signed in Succeed"
          
            self.getUserEmail()
            self.databaseRelease() //ให้มันเคลียค่าทิ้งสะก่อน
            self.databaseInit()
            //self.dismiss(animated: true, completion: nil) //ทำให้ login เสร็จแล้วมันจะปิดหน้านั้นแล้วเข้าหน้าแรกแทน

        }
       })
    }
    
    @IBAction func btnForgotPass(_ sender: Any) {
    }
    @IBAction func btnRegister(_ sender: Any) {
    }
    
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
                print(self.status)
                self.Checkstatus()
                
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
    
    func Checkstatus()
    {
        print(status)
        if status! == 1{
            //ให้ ไปเริ่มที่หน้า  login
            let AdminVC = self.storyboard?.instantiateViewController(withIdentifier: "admintabbar") as! TabbarViewController
            self.present(AdminVC, animated: true, completion: nil)
            //self.navigationController?.present(AdminVC, animated: true, completion: nil) //แบบนี้จะไม่มีหน้า back กลับ
        }
        else
        {
            let UserVC = self.storyboard?.instantiateViewController(withIdentifier: "fristview") as! ViewController
            self.present(UserVC, animated: true, completion: nil)
            //self.navigationController?.present(HomeVC, animated: true, completion: nil) //แบบนี้จะไม่มีหน้า back กลับ
        }
    }
    
    func getUserEmail()
    {
        let AuthEmail = Auth.auth().currentUser?.email //ดึง email ที่ login  อยู่ปัจจุบัน
        if AuthEmail != nil //ต้องมีค่า
        {
            ViewController.userEmail = AuthEmail
            ViewController.userEmail = replaceSpacialCharacter(inputStr:ViewController.userEmail)
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
        //การกำหนด delegate
        txtEmail.delegate=self
        txtPassword.delegate=self
       
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //เมื่อกดที่อื่น คียบอรทจะปิดการทำงาน
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //กด enter คียบอรทจะ hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return(true)
    }
  
}
