//
//  RegisterViewController.swift
//  holphak
//
//  Created by jinyada on 6/3/60.
//  Copyright © พ.ศ. 2560 jinyada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var regisEmail: UITextField!
    @IBOutlet weak var regisPass: UITextField!
    @IBOutlet weak var regisConfrimPass: UITextField!
    @IBOutlet weak var regisName: UITextField!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbpass: UILabel!
    @IBOutlet weak var lbConfrimpass: UILabel!
    @IBOutlet weak var lbSex: UILabel!
    
    var sex:String = ""
    var c:Bool = false
    @IBOutlet weak var SexSegment: UISegmentedControl!
    @IBAction func SEXsegment(_ sender: UISegmentedControl) {
        
        switch SexSegment.selectedSegmentIndex
        {
        case 0:
            sex = "man"
            c = true
        case 1:
            sex = "woman"
            c = true
        case UISegmentedControl.noSegment:
            c = true
        default:
            break
        }
        
    }
    var ref : DatabaseReference! //ไว้สำหรับอ้างอิงไปยัง database ว่าจะเก็บใน DB  ชื่ออะไร
    
    @IBAction func registerClick(_ sender: Any)
    {
        if regisName.text!.characters.count == 0
        {
            lbName.text = "กรุณากรอกชื่อผู้ใช้"
            regisEmail.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
            return
        }
        else if regisName.text!.characters.count>10
        {
            lbName.text = "กรุณากรอกไม่เกิน 10 ตัวอักษร"
            regisEmail.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 0.5)
            return
        }
        else
        {
            regisEmail.backgroundColor = UIColor.white
            lbEmail.text=""
        }
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
        }
        if c == false
        {
            lbSex.text = "กรุณาเลือกเพศ"
        }
        else
        {
            let email = regisEmail.text
            let password = regisPass.text
            var status = 0
            var join = "no"
            let name = regisName.text
            var group = "no"
            

//Auth เอาไว้เช็คว่า email นี้เคยมีคนสมัครรึยัง
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (firebaseUser, firebaseError) in
            //ถ้าเคยสมัครแล้วให้ขึ้นเตือน
                if let error = firebaseError
                {
                    Const().ShowAlert(title: "Error", message: error.localizedDescription, viewContronller: self)
                    return
                }
            //ถ้ายัง ก็ทำการสมัครและเก็บขึ้น DB
                else{
                    var MemberEmail = email
                    MemberEmail = replaceSpacialCharacter(inputStr:email!)
                    self.ref = Database.database().reference(withPath: "Member")
                    let memberData = member(name: name!, email: MemberEmail!, status: status, join:join, sex:self.sex, group: group)
                    let memberItemRef = self.ref.child(MemberEmail!) //เอาไว้แยกข้อมูลของแต่ละ user ผ่านอีเมล ถ้าไม่มีตัวนี้ข้อมูลของทุกคนจะรวมกันหมดเลย
                    memberItemRef.setValue(memberData.toAnyObject())
                
                    
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
        
        //ใน firebase ไม่สามารถใช้อักขระพิเศษได้ในการตั้งชื่อ doc เลยต้องแปลง เพื่อจะใช้ อีเมลเป็นชื่อ doc
        func replaceSpacialCharacter(inputStr:String) -> String{
            var outputStr = inputStr
            
            outputStr = outputStr.replacingOccurrences(of: ".", with: "dot")
            outputStr = outputStr.replacingOccurrences(of: "#", with: "sharp")
            outputStr = outputStr.replacingOccurrences(of: "$", with: "dollar")
            outputStr = outputStr.replacingOccurrences(of: "[", with: "stasign")
            outputStr = outputStr.replacingOccurrences(of: "}", with: "endsign")
            
            return outputStr
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
