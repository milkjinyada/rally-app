//
//  ViewcontrollerScore.swift
//  RankingScore
//
//  Created by Kievy on 10/4/2562 BE.
//  Copyright © 2562 Kievy. All rights reserved.
//
import UIKit
import Foundation
import Firebase

class ViewcontrollerScore: UIViewController{
    
    var ref = DatabaseReference.init()
    var create: DatabaseReference!
    var arrData = [RankScoree]()
    var numOfGroup = [Int]()
    
    
    
    
    @IBOutlet var firstScore: UILabel!
    @IBOutlet var secondScore: UILabel!
    @IBOutlet var thirdScore: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var secondName: UILabel!
    @IBOutlet var thirdName: UILabel!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        self.fetchScore()
        //self.getAllFIRData()
        //random()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getAllFIRData() {
        
        if (AdminHomeViewController.ChannelName.isEmpty == false){
            let databaseRef = Database.database().reference()
            databaseRef.child("Ranking").child("\(AdminHomeViewController.ChannelName)").queryOrdered(byChild:"Group").observeSingleEvent(of: .value, with: { snapshot in
                
                if snapshot.exists(){
                    self.create = Database.database().reference().child("Ranking").child("\(AdminHomeViewController.ChannelName)").child("Group")
                    self.create.observe(DataEventType.value, with: {(snapshot) in
                        self.arrData.removeAll()
                        if let snapShort = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapShort{
                                if let mainDict = snap.value as? [String: AnyObject]{
                                    let  Groupname = mainDict["Groupname"] as? String
                                    let  Picture = mainDict["Picture"] as? Int
                                    let  Math = mainDict["Math"] as? Int
                                    let  Run = mainDict["Run"] as? Int
                                    let  AR = mainDict["AR"] as? Int
                                    let  Question = mainDict["Question"] as? Int
                                    
                                    var gameSum:Int
                                    gameSum = Int(Picture!+Math!+Run!+AR!+Question!)
                                    print(gameSum)
                                    
                                    self.arrData.append(RankScoree(Groupname: Groupname!, gameSum: gameSum))
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    })
                }
            })
        }
        
        
        
        
    }
    
    
    
    func fetchScore() {
        
        if (AdminHomeViewController.ChannelName.isEmpty == false){
            let databaseRef = Database.database().reference()
            
            databaseRef.child("Ranking").child("\(AdminHomeViewController.ChannelName)").queryOrdered(byChild:"Group").observeSingleEvent(of: .value, with: { snapshot in
                
                if snapshot.exists(){
                    
                    self.create = Database.database().reference().child("Ranking").child("\(AdminHomeViewController.ChannelName)").child("Group")
                    self.create.observe(DataEventType.value, with: {(snapshot) in
                        
                        print("snap")
                        
                        var snapshotArray: [DataSnapshot] = []
                        for item in snapshot.children {
                            snapshotArray.append(item as! DataSnapshot)
                        }
                        snapshotArray.reverse()
                        var rankArray: [Ranking] = []
                        
                        for snap in snapshotArray {
                            
                            let ranking = Ranking(dic: snap.value as! [String: Any])
                            rankArray.append(ranking)
                            rankArray.sort(by: {$0.Picture+$0.Math+$0.Run+$0.AR+$0.Question > $1.Picture+$1.Math+$1.Run+$1.AR+$1.Question})
                        }
                        
                        
                        for (index, ranking) in rankArray.enumerated() {
                            
                            if index == 0 {
                                self.firstName.text = "Group: \(ranking.Groupname)"
                                self.firstScore.text = "\(ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question) P"
                            }else if index == 1 {
                                self.secondName.text = "Group: \(ranking.Groupname)"
                                self.secondScore.text = "\(ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question) P"
                            }else if index == 2 {
                                self.thirdName.text = "Group: \(ranking.Groupname)"
                                self.thirdScore.text = "\(ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question) P"
                            }else{
                                self.getAllFIRData()
                            }
                        }
                    })
                }
            })
        }
        
        
        
    }
    
    
    class Ranking {
        
        var Groupname: String = ""
        var Picture: Int = 0
        var Math: Int = 0
        var Run: Int = 0
        var AR: Int = 0
        var Question: Int = 0
        
        init(dic: [String: Any]) {
            
            self.Groupname = dic["Groupname"] as? String ?? ""
            self.Picture = dic["Picture"] as? Int ?? 0
            self.Math = dic["Math"] as? Int ?? 0
            self.Run = dic["Run"] as? Int ?? 0
            self.AR = dic["AR"] as? Int ?? 0
            self.Question = dic["Question"] as? Int ?? 0
        }
        
    }
}




extension ViewcontrollerScore: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count-3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCellScore
        
        arrData.sort(by: {$0.gameSum > $1.gameSum})
        let test = arrData[indexPath.row+3]
        cell.nameLabel.text = ("Group: \(String(describing: test.Groupname!))")
        cell.scoreLabel.text = ("\(String(describing: test.gameSum)) P")
        
        for i in 0...indexPath.row{
            cell.NumberFourtoN.text! = String(i+4)
        }
        
        return cell
    }
    
}




