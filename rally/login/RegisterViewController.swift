//
//  RegisterViewController.swift
//  holphak
//
//  Created by jinyada on 6/3/60.
//  Copyright © พ.ศ. 2560 jinyada. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var regisEmail: UITextField!
    @IBOutlet weak var regisPass: UITextField!
    @IBOutlet weak var regisConfrimPass: UITextField!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbpass: UILabel!
    @IBOutlet weak var lbConfrimpass: UILabel!
   
    @IBAction func registerClick(_ sender: Any)
    {
        if regisEmail.text!.characters.count<6
        {
            lbEmail.text = "อีเมลไม่ถูกต้อง"
            regisEmail.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
            return
        }
        else
        {
            regisEmail.backgroundColor = UIColor.white
            lbEmail.text=""
        }
        if regisPass.text!.characters.count<6
        {
            lbpass.text = "รหัสผ่านต้องมากกว่า 6 อักขระ"
           regisPass.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
           
            return
        }
        else
        {
            regisPass.backgroundColor = UIColor.white
            lbpass.text=""
        }
        if regisConfrimPass.text!.isEqual(regisPass.text!) == false
        {
            lbConfrimpass.text = "กรุณากรอกรหัสผ่านให้ตรงกัน"
            regisConfrimPass.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
            return
        }
        else
        {
            regisConfrimPass.backgroundColor = UIColor.white
            lbConfrimpass.text=""
            
            let email = regisEmail.text
            let password = regisPass.text
            
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (firebaseUser, firebaseError) in
                if let error = firebaseError
                {
                    Const().ShowAlert(title: "Error", message: error.localizedDescription, viewContronller: self)
                    return
                }
                else{
                    let alert = UIAlertController(title: "Succeed", message: "Sign in Succeed", preferredStyle: .alert)
                    let resultAlert = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(resultAlert)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    return
                }
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //hide keyboard when user touches outside keyborad
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    //presses reture key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return(true)
    }

    
}
