//
//  RegisterViewController.swift
//  holphak
//
//  Created by jinyada on 6/3/60.
//  Copyright © พ.ศ. 2560 jinyada. All rights reserved.
//

import Foundation
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
    @IBOutlet weak var profileImageView: UIImageView!
    var sex:String = ""
    var c:Bool = false
    var imagePicker:UIImagePickerController!
    var useremail:String=""
    
    
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
//        case UISegmentedControl.UISegmentedControlNoSegment:
//            c = true
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
            var photourl = ""
            

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
                    self.useremail = MemberEmail!
                    self.ref = Database.database().reference(withPath: "Member")
                    let memberData = member(name: name!, email: MemberEmail!, status: status, join:join, sex:self.sex, group: group, photoURL:photourl)
                    let memberItemRef = self.ref.child(MemberEmail!) //เอาไว้แยกข้อมูลของแต่ละ user ผ่านอีเมล ถ้าไม่มีตัวนี้ข้อมูลของทุกคนจะรวมกันหมดเลย
                    memberItemRef.setValue(memberData.toAnyObject())
                    self.handleSignUp()

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
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        //tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
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
    
    //อัพโหลดรูปโปรไฟล์
    @objc func handleSignUp() {
        guard let username = regisEmail.text else { return }
        guard let image = profileImageView.image else { return }
        
        // 1. Upload the profile image to Firebase Storage
        self.uploadProfileImage(image) { url in
            
            if url != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.photoURL = url
                
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed!")
                        
                        self.saveProfile(username: username, profileImageURL: url!) { success in
                            if success {
                                print("success")
                            }
                        }
                        
                    } else {
                        print("Error: \(error!.localizedDescription)")
                    }
                }
            } else {
                print("Error unable to upload profile image")
            }
            
        }
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(useremail)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                if let url = metaData?.downloadURL()  {
                    completion(url)
                } else {
                    completion(nil)
                }
                // success!
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
    //เก็บ URL ของรูปโปรไฟล์ขึ้น Firebase
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        // guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(useremail)")
        
        let userObject = [
            "username": username,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
        
        let MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
        let photoItemRef = MemberRef.child(useremail)
        print(useremail)
        let imgurl = ["photoURL": profileImageURL.absoluteString] as [String:Any]
        photoItemRef.updateChildValues(imgurl)
    }

}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

}

