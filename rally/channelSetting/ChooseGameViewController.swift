//
//  ChooseGameViewController.swift
//  rally
//
//  Created by Jinyada on 23/2/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class ChooseGameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var gamenum:String = ""
    static var counter:Bool = false
    var choosegamecount:Bool = false
    
    
    
    var ref : DatabaseReference! = Database.database().reference(withPath: "Member")
    
    
    @IBOutlet weak var Alertlb: UILabel!
    @IBOutlet weak var titel: UILabel!
    @IBOutlet weak var Gamenamelb: UILabel!
    @IBOutlet weak var GameListpicker: UIPickerView!
    @IBOutlet var fame: UIImageView!
    @IBOutlet var whitefame: UIImageView!
    @IBOutlet var buttonselectgame: UIButton!
    @IBAction func ChooseGamebtn(_ sender: Any) {
        
        GameListpicker.isHidden = false
        datail.isHidden = true
    }
    @IBOutlet weak var datail: UITextView!
    
    @IBAction func chooselocationbtn(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationMap") as! UINavigationController
        self.present(viewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func savegamebtn(_ sender: Any) {
        
        if ChooseGameViewController.counter == true && choosegamecount == false{
            Alertlb.text = "Please select game"
            
        }
        if ChooseGameViewController.counter == false && choosegamecount == false {
            Alertlb.text = "Please select game's location"
            
        }
        else
        {
            if choosegamecount && ChooseGameViewController.counter == true{
                GameSettingViewController.listgame[GameSettingViewController.n] = (Gamenamelb.text!)
                GameSettingViewController.imgname[GameSettingViewController.n] = "covergame"
                ChooseGameViewController.counter = false
                choosegamecount = false
                
                let gamename: String = Gamenamelb.text!
                // SAVE ข้อมูลเกมขึ้น Firebase
                
                let dict = ["gamename":"\(gamename)","latitude": AddGeofenceViewController.lat,"longitude":AddGeofenceViewController.long,"radius":AddGeofenceViewController.radiusString,"identifier":AddGeofenceViewController.identifierString,"note":AddGeofenceViewController.noteString,"eventType":AddGeofenceViewController.eventTypeString] as [String: Any]
                self.ref.child("\(ViewController.userEmail!)/channeldata/game/\(GameSettingViewController.n)").setValue(dict)
                //
                
                let homeView = self.storyboard?.instantiateViewController(withIdentifier: "gamesetting") as! GameSettingViewController
                self.present(homeView, animated: true, completion: nil)
                
            }
            
            
        }
        
    }
    
    
    
    let Games = ["เกมถามตอบ", "เกมสลับภาพ", "เกมปาขวาน", "เกมเดินให้ดี", "เกมบวกเลข"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return Games[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Games.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        Gamenamelb.text = Games[row]
        GameListpicker.isHidden = true
        datail.isHidden = false
        
        switch row {
        case 0:
            datail.text = "เกมถาม - ตอบ เป็นเกมเกี่ยวกับการตอบคำถามตามโจทย์ที่ผู้ดูแลได้ตั้งขึ้น"
            choosegamecount = true
        case 1:
            datail.text = "เป็นเกมที่ให้ผู้ดูแลกำหนดภาพขึ้นมา 1 ภาพ และให้ผู้เล่นสลับช่องภาพให้ตรงกับภาพต้นฉบับ"
            choosegamecount = true
        case 2:
            datail.text = "จะต้องปาขวานให้โดนอ่างน้ำและฉลาม ตามภาพที่ได้เห็น"
            choosegamecount = true
        case 3:
            datail.text = "ผู้เล่นจะต้องจับคู่ภาพที่ตรงกันให้ได้มากที่สุดตามเวลาที่กำหนด"
            choosegamecount = true
        case 4:
            datail.text = "จับผิดภาพที่แตกต่างกันจากภาพที่ผู้ดูแลกำหนด จำนวน 5 จุด"
            choosegamecount = true
        default:
            datail.text = "คำอธิบายเกม"
            choosegamecount = false
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "DB ADMAN X", size:20)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Games[row]
        //pickerLabel?.textColor = UIColor.blue
        
        return pickerLabel!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titel.text = "Choose Game\(gamenum)"
        datail.isHidden = true
        
        
        if ChooseGameViewController.counter == true && choosegamecount == false{
            //Alertlb.text = "Please select game"
            Gamenamelb.isHidden = false
            GameListpicker.isHidden = false
            fame.isHidden = false
            whitefame.isHidden = false
            buttonselectgame.isHidden = false
        }
        if ChooseGameViewController.counter == false && choosegamecount == false {
            //Alertlb.text = "Please select game's location"
            Gamenamelb.isHidden = true
            GameListpicker.isHidden = true
            fame.isHidden = true
            whitefame.isHidden = true
            buttonselectgame.isHidden = true
            
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //ส่งข้อมูลผ่านสาย segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //ส่งจำนวน Mission ที่ผู้ดูแลเลือกไป เพื่อเลือกเกมในแต่ละ Mission
        if segue.identifier == "savegame" {
            
            let GamesettingView = segue.destination as! GameSettingViewController
            GamesettingView.gamename =  Gamenamelb.text!
        }
    }
    
    
}

