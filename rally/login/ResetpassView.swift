//
//  ResetpassView.swift
//  holphak
//
//  Created by jinyada on 6/3/60.
//  Copyright © พ.ศ. 2560 jinyada. All rights reserved.
//

import UIKit
import Firebase

class ResetpassView: UIViewController {
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBAction func btnResetPass(_ sender: Any)
    {
        let email = txtEmail.text
        Auth.auth().sendPasswordReset(withEmail: email!, completion: { (firebaseError) in
            if let error = firebaseError
            {
                Const().ShowAlert(title: "Error", message: error.localizedDescription, viewContronller: self)
                
                return
            }
            else{
                let alert = UIAlertController(title: "Succeed", message: "รหัสผ่านใหม่ได้ส่งเข้าไปในอีเมลของคุณ", preferredStyle: .alert)
                let resultAlert = UIAlertAction(title: "OK", style: .default, handler: { (alertaction) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                alert.addAction(resultAlert)
                self.present(alert, animated: true, completion: nil)
    
                return
            }
        })
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
