//
//  AdminHomeViewController.swift
//  rally
//
//  Created by Jinyada on 17/1/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase

class AdminHomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    

    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
    var users = [User]()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var channelname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var missionnum: UILabel!
    @IBOutlet weak var groupnum: UILabel!
    @IBOutlet weak var timepermission: UILabel!
    
    var num = [Int]()
    var sex = [String]()
    var status = [String]()

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membercell", for: indexPath) as! tbMemberCell
        
        let user = users[indexPath.row]
        let row = indexPath.row
        cell.membernum.text = String(num[row])
        cell.memberusername.text = user.name
        cell.membergroup.text = user.group
        cell.membersex.image = UIImage(named: user.sex!)
        cell.memberstatus.image = UIImage(named: user.join!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 68.0;//Choose your custom row height
    }
    
    func fetchUser() {
        Database.database().reference().child("Member").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                let user = User()
                user.name = dictionary["name"] as? String
                user.group = dictionary["group"] as? String
                user.sex = dictionary["sex"] as? String
                user.join = dictionary["join"] as? String
                user.status = dictionary["status"] as? Int
            //เช็ค status ว่าเป็น ผู้ใช้หรือ admin ถ้าเป็น ผู้ใช้ ถึงเพิ่มชื่อเข้าไปใน tb
                if user.status == 0 {
                    self.users.append(user)
                    DispatchQueue.main.async {
                        self.Num()
                        self.tableview.reloadData()
                    }
                }
                
                
            }
        })
    }
    
    func Num() {
    
        for i in 1...users.count
        {
            num.append(i)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()

    }
}

