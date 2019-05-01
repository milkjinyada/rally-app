//
//  SettingsChannelViewController.swift
//  rally
//
//  Created by Jinyada on 17/1/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsChannelViewController: UIViewController {
    
    var userEmail:String! = ""
    var mission : String = ""
    var time : String = ""
    var group : String = ""
    var grouping : String = ""
    var roomname : String = ""
    var PhotoURL : String = ""

    @IBOutlet weak var channelname: UILabel!
    @IBOutlet weak var missionnum: UILabel!
    @IBOutlet weak var timenum: UILabel!
    @IBOutlet weak var groupnum: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var imagePicker:UIImagePickerController!
    
    @IBAction func MissionStp(_ sender: UIStepper) {
        missionnum.text = String(Int(sender.value))
        mission = String(Int(sender.value))
    }
    @IBAction func TimeStp(_ sender: UIStepper) {
        timenum.text = String(Int(sender.value))
        time = String(Int(sender.value))
    }
    @IBAction func GroupStp(_ sender: UIStepper) {
        groupnum.text = String(Int(sender.value))
        group = String(Int(sender.value))
    }
    
    

//เก็บ Rally Setting ขึ้น firebase
    
    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
    @IBAction func SettingChannelbtn(_ sender: Any) {
        let SettingData: Dictionary<String,AnyObject> =
            [
                "ChannelName" : self.roomname as AnyObject,
                "Mission" : self.mission as AnyObject,
                "Time": self.time as AnyObject,
                "Group": self.group as AnyObject,
            ]
        
        let SettingItemRef = self.MemberRef.child("\(self.userEmail!)/channeldata")
        SettingItemRef.setValue(SettingData)//ส่งขึ้น firebase
        handleSignUp()
    }
    
//ดึงข้อมูลชื่อ channel จาก firebase
    var databaseRef:DatabaseReference! //กำหนด ref
    var UserRef:DatabaseReference! //กำหนด ref
    private var _databaseHandle:DatabaseHandle! = nil //กำหนด  handle
    
    func databaseInit()
    {
        databaseRef = Database.database().reference().child("Member").child(userEmail!) //ดึง ref
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String:AnyObject]
            {
                //เอาค่าจาก firbase มาใส่ไว้ในตัวแปร
              
                var strSenderChannelName = ""
               
                if let strTemp = snapshot["channelname"] as? String
                {
                    strSenderChannelName = strTemp
                }
                else
                {
                    strSenderChannelName = ""
                }
                
                self.channelname.text = strSenderChannelName
                self.roomname = strSenderChannelName
            }
        })
        
        //ดึง URL มาใส่รูป profile
        UserRef = Database.database().reference().child("users/profile/\(userEmail!)")
        UserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String:AnyObject]
            {
                //เอาค่าจาก firbase มาใส่ไว้ในตัวแปร
                
                var url = ""
                
                if let strTemp = snapshot["photoURL"] as? String
                {
                    url = strTemp
                }
                else
                {
                    url = ""
                }
                
                self.PhotoURL = url
                //ดึงรูปโปรไฟล์มาจาก Firebase
                ImageService.getImage(withURL: URL(string:url)!) { image, url in
                    self.profileImageView.image = image
                    
                }
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
    
    override func viewWillAppear(_ animated: Bool) {
        getUserEmail()
    }
    
    func getUserEmail()
    {
        let AuthEmail = Auth.auth().currentUser?.email //ดึง email ที่ login  อยู่ปัจจุบัน
        if AuthEmail != nil //ต้องมีค่า
        {
            userEmail = AuthEmail
            userEmail = replaceSpacialCharacter(inputStr:userEmail)
            
            databaseRelease() //ให้มันเคลียค่าทิ้งสะก่อน
            databaseInit()
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
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    
        // Do any additional setup after loading the view.
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    //ส่งข้อมูลผ่านสาย segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //ส่งจำนวน Mission ที่ผู้ดูแลเลือกไป เพื่อเลือกเกมในแต่ละ Mission
        if segue.identifier == "gamesetting" {
            
            let GamesettingView = segue.destination as! GameSettingViewController
            GamesettingView.game = Int(mission)!
        }
    }
    
    
//อัพโหลดรูปโปรไฟล์
    @objc func handleSignUp() {
        guard let username = userEmail else { return }
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
        let storageRef = Storage.storage().reference().child("user/\(userEmail!)")
        
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
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
       // guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(userEmail!)")
        let userObject = [
            "username": username,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
}

extension SettingsChannelViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
