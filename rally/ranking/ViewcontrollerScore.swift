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
    
    var channelname:String = ""
    var ref = DatabaseReference.init()
    var create: DatabaseReference!
    var arrData = [RankScoree]()
    var numOfGroup = [Int]()
    
    @IBOutlet weak var firstPic: UIImageView!
    @IBOutlet weak var secondPic: UIImageView!
    @IBOutlet weak var thirdPic: UIImageView!
    @IBOutlet var firstScore: UILabel!
    @IBOutlet var secondScore: UILabel!
    @IBOutlet var thirdScore: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var secondName: UILabel!
    @IBOutlet var thirdName: UILabel!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AdminHomeViewController.ChannelName.isEmpty == false{
             self.channelname = AdminHomeViewController.ChannelName
        }
        else{
            self.channelname = UserHomeViewController.Channelname
        }
        
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
       
        if (channelname.isEmpty == false){
            let databaseRef = Database.database().reference()
            databaseRef.child("Ranking").child("\(channelname)").queryOrdered(byChild:"Group").observeSingleEvent(of: .value, with: { snapshot in
                
                if snapshot.exists(){
                    self.create = Database.database().reference().child("Ranking").child("\(self.channelname)").child("Group")
                    self.create.observe(DataEventType.value, with: {(snapshot) in
                        self.arrData.removeAll()
                        if let snapShort = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapShort{
                                if let mainDict = snap.value as? [String: AnyObject]{
                                    let  Username = mainDict["Username"] as? String
                                    let  Email = mainDict["Email"] as? String
                                    let  Photourl = mainDict["photoURL"] as? String
                                    let  Picture = mainDict["Picture"] as? Int
                                    let  Math = mainDict["Math"] as? Int
                                    let  Run = mainDict["Run"] as? Int
                                    let  AR = mainDict["AR"] as? Int
                                    let  Question = mainDict["Question"] as? Int
                                    
                                    var gameSum:Int
                                    gameSum = Int(Picture!+Math!+Run!+AR!+Question!)
                                    print(gameSum)
                                    
                                    self.arrData.append(RankScoree(Username: Username!, gameSum: gameSum, photoURL: Photourl!, Email: Email!))
                                    
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
        
        if (channelname.isEmpty == false){
            let databaseRef = Database.database().reference()
            
            databaseRef.child("Ranking").child("\(channelname)").queryOrdered(byChild:"Group").observeSingleEvent(of: .value, with: { snapshot in
                
                if snapshot.exists(){
                    
                    self.create = Database.database().reference().child("Ranking").child("\(self.channelname)").child("Group")
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
                            var sumscore:Int = 0
                            if index == 0 {
                                self.firstName.text = (ranking.Username)
                                self.firstScore.text = "\(ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question) P"
                                sumscore = ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question
                                //ดึงรูปโปรไฟล์มาจาก Firebase
                                ImageService.getImage(withURL: URL(string:ranking.PhotoURL)!) { image, url in
                                    //ทำรูปให้เป็นวงกลม
                                    self.firstPic.image = image
                                    self.firstPic.layer.cornerRadius = self.firstPic.bounds.height / 2
                                    self.firstPic.clipsToBounds = true
                                }
                                
                                //เก็บคะแนนขึ้น firebase
                                let MemberRef : DatabaseReference! = Database.database().reference().child("Ranking").child("\(self.channelname)").child("Group")
                                let SetScoreData: Dictionary<String,AnyObject> =
                                    ["SUMScore" : sumscore as AnyObject]
                                print(ranking.Email)
                                if ranking.Email.isEmpty == false{
                                    let ScoreItemRef = MemberRef.child(ranking.Email)
                                    ScoreItemRef.updateChildValues(SetScoreData)
                                }
                                
                            }else if index == 1 {
                                self.secondName.text = (ranking.Username)
                                self.secondScore.text = "\(ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question) P"
                                sumscore = ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question
                                //ดึงรูปโปรไฟล์มาจาก Firebase
                                ImageService.getImage(withURL: URL(string:ranking.PhotoURL)!) { image, url in
                                    //ทำรูปให้เป็นวงกลม
                                    self.secondPic.image = image
                                    self.secondPic.layer.cornerRadius = self.secondPic.bounds.height / 2
                                    self.secondPic.clipsToBounds = true
                                }
                                //เก็บคะแนนขึ้น firebase
                                let MemberRef : DatabaseReference! = Database.database().reference().child("Ranking").child("\(self.channelname)").child("Group")
                                let SetScoreData: Dictionary<String,AnyObject> =
                                    ["SUMScore" : sumscore as AnyObject]
                                print(ranking.Email)
                                if ranking.Email.isEmpty == false{
                                    let ScoreItemRef = MemberRef.child(ranking.Email)
                                    ScoreItemRef.updateChildValues(SetScoreData)
                                }
                            }else if index == 2 {
                                self.thirdName.text = (ranking.Username)
                                self.thirdScore.text = "\(ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question) P"
                                sumscore = ranking.Picture+ranking.Math+ranking.Run+ranking.AR+ranking.Question
                                //ดึงรูปโปรไฟล์มาจาก Firebase
                                ImageService.getImage(withURL: URL(string:ranking.PhotoURL)!) { image, url in
                                    //ทำรูปให้เป็นวงกลม
                                    self.thirdPic.image = image
                                    self.thirdPic.layer.cornerRadius = self.thirdPic.bounds.height / 2
                                    self.thirdPic.clipsToBounds = true
                                }
                                //เก็บคะแนนขึ้น firebase
                                let MemberRef : DatabaseReference! = Database.database().reference().child("Ranking").child("\(self.channelname)").child("Group")
                                let SetScoreData: Dictionary<String,AnyObject> =
                                    ["SUMScore" : sumscore as AnyObject]
                                print(ranking.Email)
                                if ranking.Email.isEmpty == false{
                                    let ScoreItemRef = MemberRef.child(ranking.Email)
                                    ScoreItemRef.updateChildValues(SetScoreData)
                                }
                                
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
        
        var Username: String = ""
        var Email: String = ""
        var PhotoURL:String = ""
        var Picture: Int = 0
        var Math: Int = 0
        var Run: Int = 0
        var AR: Int = 0
        var Question: Int = 0
        
        init(dic: [String: Any]) {
            
            self.Username = dic["Username"] as? String ?? ""
            self.Email = dic["Email"] as? String ?? ""
            self.PhotoURL = dic["photoURL"] as? String ?? ""
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
        print(arrData.sort(by: {$0.gameSum > $1.gameSum}))
        let test = arrData[indexPath.row+3]
        cell.nameLabel.text = (String(describing: test.Username!))
        cell.scoreLabel.text = ("\(String(describing: test.gameSum)) P")
        var sumscore = test.gameSum
        
        //เก็บคะแนนขึ้น firebase
        let MemberRef : DatabaseReference! = Database.database().reference().child("Ranking").child("\(self.channelname)").child("Group")
        let SetScoreData: Dictionary<String,AnyObject> =
            ["SUMScore" : sumscore as AnyObject]
     
        if test.Email!.isEmpty == false{
            let ScoreItemRef = MemberRef.child(test.Email!)
            ScoreItemRef.updateChildValues(SetScoreData)
        }
        
        //ดึงรูปโปรไฟล์มาจาก Firebase
        ImageService.getImage(withURL: URL(string:test.photoUrl!)!) { image, url in
            //ทำรูปให้เป็นวงกลม
            cell.memberPic.image = image
            cell.memberPic.layer.cornerRadius = cell.memberPic.bounds.height / 2
            cell.memberPic.clipsToBounds = true
        }
        
        for i in 0...indexPath.row{
            cell.NumberFourtoN.text! = String(i+4)
        }
        
        return cell
    }
    
}




