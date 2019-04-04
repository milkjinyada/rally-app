//
//  GameSettingViewController.swift
//  rally
//
//  Created by Jinyada on 12/2/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase



class GameSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    static var n = 1
    static var listgame = [String]()
    static var imgname = [String]()
    
    @IBOutlet weak var tableview: UITableView!
    
    var game:Int = 0
    var num = [Int]()
    var gamename:String = "Please choose the game."
    var gamedetail:String = ""
    var check:Bool = false
    var mission:Int = 0
    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
    
    @IBAction func CreateChanelBtn(_ sender: Any) {
        
        // เก็บรายชื่อเกมขึ้น Firbase
        // let SettingItemRef = self.MemberRef.child("\(self.userEmail!)/channeldata/game")
        // SettingItemRef.setValue(GameSettingViewController.listgame)//ส่งขึ้น firebase
        
    }
    var gamenum:Int!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mission
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listgamecell", for: indexPath) as? GameSettingCell else { return UITableViewCell() }
        let row = indexPath.row
        
        cell.choosegametext.text = GameSettingViewController.listgame[row]
        cell.game.text = "GAME"
        cell.gamenum.text = String(num[row])
        cell.gameimg.setImage(UIImage(named: GameSettingViewController.imgname[row]), for: .normal)
        cell.gameimg.tag = indexPath.row
        cell.gameimg.addTarget(self, action: "pressButton:", for: .touchUpInside)
        
        return cell
    }
 

    @objc func pressButton(_ sender: UIButton){ //<- needs `@objc`
        GameSettingViewController.n = sender.tag
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0;//Choose your custom row height
    }
    
    func Num() {
        for i in 1...mission
        {
            num.append(i)
        }
        if GameSettingViewController.listgame.count < num.count {
            for n in 1...mission{
                GameSettingViewController.listgame.append("Please choose the game.")
                print(GameSettingViewController.listgame)
            }
        }
        if GameSettingViewController.imgname.count < num.count {
            for m in 1...mission{
                GameSettingViewController.imgname.append("choosegamecell")
            }
        }
        tableview.reloadData()
    }
    
    var databaseRef:DatabaseReference!
    var channeldataRef:DatabaseReference!
    private var _databaseHandle:DatabaseHandle! = nil //กำหนด  handle
    var userEmail:String! = "" //ไว้เก็บบัญชีผู้ใช้
    
    func databaseInit()
    {
        channeldataRef = Database.database().reference().child("Member").child("\(self.userEmail!)/channeldata")
        channeldataRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String:AnyObject]
            {
                //เอาค่าจาก firbase มาใส่ไว้ในตัวแปร
                var strSenderMission = ""
                if let strTemp = snapshot["Mission"] as? String
                {
                    strSenderMission = strTemp
                }
                else
                {
                    strSenderMission = ""
                }
                
                self.mission = Int(strSenderMission)!
               
                self.Num()
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
        getUserEmail()
        
   
    }
    
    //ส่งข้อมูลผ่านสาย segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //ส่งจำนวน Mission ที่ผู้ดูแลเลือกไป เพื่อเลือกเกมในแต่ละ Mission
        if segue.identifier == "choosegame" {
            
            let ChoosegameView = segue.destination as! ChooseGameViewController
            ChoosegameView.gamenum =  "2"
          
        }
    }

    
}
