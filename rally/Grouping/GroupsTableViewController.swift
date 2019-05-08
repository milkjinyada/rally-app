
//  GroupController.swift
//  rally
//
//  Created by Jinyada on 22/24/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class GroupsTableViewController: UITableViewController {

    let groupController = RandomGroupController(groupSizeTarget: 14, groupsOfOneFine: false)

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var groupeSizeStepper: UIStepper!
    
    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
    var groupnum:Int = 0
    var membernum:Int = 0
    var israndom:Bool = false
    
    //var Memberlist = [Int:[Int:String]]()
    var Memberlist = [[String]](repeating: [String](repeating: "0", count: 1), count: 1)
    
    @IBAction func savegroupingbtn(_ sender: Any) {
       
    // เก็บรายชื่อกลุ่มขึ้น firebase
        let SettingGroupRef = self.MemberRef.child("\(AdminHomeViewController.userEmail!)/Grouplist")
        SettingGroupRef.setValue(Memberlist)//ส่งขึ้น firebase
        
        

        
        let AdminVC = self.storyboard?.instantiateViewController(withIdentifier: "admintabbar") as! TabbarViewController
        self.present(AdminVC, animated: true, completion: nil)
   
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateGroupSizeDisplay()
        random()
    }
    
    private func updateGroupSizeDisplay(){
        groupSizeLabel.text = "Group Size: \(Int(groupeSizeStepper.value))"
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
       //จำนวนกลุ่ม
        groupnum = groupController.groups.count
        return groupController.groups.count
        
      
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //จำนวนสมาชิก
        membernum = groupController.groups[section].members.count
        Memberlist = [[String]](repeating: [String](repeating:"", count: membernum), count: groupnum)
        return groupController.groups[section].members.count
        

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberNameCell", for: indexPath)
        
        
                 if let member = groupController.groups[indexPath.section].members[indexPath.row] as? Member
                 {
                    cell.textLabel?.text = member.name

                    //Memberlist[indexPath.section] = [indexPath.row:member.name]
                    Memberlist[indexPath.section][indexPath.row] = member.name
               
                    if israndom == true{
                        //update ชื่อกลุ่มของสมาชิก
                        Database.database().reference().child("Member").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            for snap in snapshot.children {
                                
                                let recipeSnap = snap as! DataSnapshot
                                let dict = recipeSnap.value as! [String:AnyObject]
                                let recipeName = dict["name"] as! String
                                let recipeEmail = dict["email"] as! String
                                
                                print(recipeName)
                                print(recipeEmail)
                                
                                if recipeName == (member.name)  {
                                    Database.database().reference().child("Member").child(recipeEmail ?? "").updateChildValues(["group": String(indexPath.section+1)])
                                    self.israndom = false
                                }
                            }
                        })
                    }
                }
        return cell
    }
        
    //เลือกว่าต้องการให้มีกี่กลุ่ม
    @IBAction func groupSizeStepperValueChanged(_ sender: UIStepper) {
        groupController.sizeTarget = Int(sender.value)
        updateGroupSizeDisplay()
    }
    
    
    //กด Random กลุ่ม
    @IBAction func randomizeGroupsTapped(_ sender: UIButton) {
        israndom = true
        groupController.randomizeGroups()
        tableView.reloadData()
    }
    
    //ดึงรายชื่อมาจาก firebase เข้า Tableview
   var myCallList = [Namegroup]()
   var ref = DatabaseReference.init()
    func random() {

            Database.database().reference().child("Member").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any]{
                    let user = User()
                    user.name = dictionary["name"] as? String
                    user.Channel = dictionary["Channel"] as? String
                    
                    //เช็คว่า member ไหนเป็น สมาชิกของห้องนี้บ้าง ถึงค่อยเพิ่มชื่อเข้าไปใน tb
                    if user.Channel == (AdminHomeViewController.ChannelName) {
                        self.groupController.nonRandomAddMember(withName: user.name!)
                        self.tableView.reloadData()
                
                    }
                }
            })
        }
    
//ลบรายชื่อใน Table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let member = groupController.groups[indexPath.section].members[indexPath.row] as? Member else {
                NSLog("Tried to delete member, but the item found was not a member.")
                return
            }
            groupController.delete(member: member)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


extension GroupsTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
