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
            self.dismiss(animated: true, completion: nil) //ทำให้ login เสร็จแล้วมันจะปิดหน้านั้นแล้วเข้าหน้าแรกแทน
            
        }
       })
    }
    
    @IBAction func btnForgotPass(_ sender: Any) {
    }
    @IBAction func btnRegister(_ sender: Any) {
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
