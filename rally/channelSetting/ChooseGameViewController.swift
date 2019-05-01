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

    
    var ref : DatabaseReference! = Database.database().reference(withPath: "Member")
    
    @IBOutlet weak var Alertlb: UILabel!
    @IBOutlet weak var titel: UILabel!
    @IBOutlet weak var Gamenamelb: UILabel!
    @IBOutlet weak var GameListpicker: UIPickerView!
    @IBAction func ChooseGamebtn(_ sender: Any) {
        GameListpicker.isHidden = false
        datail.isHidden = true
    }
    @IBOutlet weak var datail: UITextView!
    
    @IBAction func chooselocationbtn(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationMap") as! UINavigationController
        self.present(viewController, animated: true, completion: nil)
        
//        counter = true
//
//        var gamename: String = Gamenamelb.text!
//        var desgame: String = datail.text!
//        let viewController = LocationPickerController(success: {
//            [weak self] (coordinate: CLLocationCoordinate2D) -> Void in
//
//            var lat : String
//            var long : String
//            lat = "".appendingFormat("%.8f", coordinate.latitude)
//            long = "".appendingFormat("%.8f", coordinate.longitude)
//
//            print(lat)
//            print(long)
//
//            //SAVE ข้อมูลเกมขึ้น Firebase
//            let dict = ["name":"\(gamename)","lat": lat,"long": long,"Description":"\(desgame)"] as [String: Any]
//            self?.ref.child("\(ViewController.userEmail!)/channeldata/game/\(GameSettingViewController.n)").setValue(dict)
//
//
//        })
//        let navigationController = UINavigationController(rootViewController: viewController)
//        self.present(navigationController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func savegamebtn(_ sender: Any) {
        
        if ChooseGameViewController.counter == false{
            Alertlb.text = "กรุณาเลือกสถานที่สำหรับเกมนี้"
        }
        else
        {
            GameSettingViewController.listgame[GameSettingViewController.n] = (Gamenamelb.text!)
            GameSettingViewController.imgname[GameSettingViewController.n] = "covergame"
            ChooseGameViewController.counter = false
            
            var gamename: String = Gamenamelb.text!
            // SAVE ข้อมูลเกมขึ้น Firebase
            
            let dict = ["gamename":"\(gamename)","latitude": AddGeofenceViewController.lat,"longitude":AddGeofenceViewController.long,"radius":AddGeofenceViewController.radiusString,"identifier":AddGeofenceViewController.identifierString,"note":AddGeofenceViewController.noteString,"eventType":AddGeofenceViewController.eventTypeString] as [String: Any]
            self.ref.child("\(ViewController.userEmail!)/channeldata/game/\(GameSettingViewController.n)").setValue(dict)
            //
            
            
            
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "gamesetting") as! GameSettingViewController
            self.present(homeView, animated: true, completion: nil)
            
            
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
        case 1:
            datail.text = "เป็นเกมที่ให้ผู้ดูแลกำหนดภาพขึ้นมา 1 ภาพ และให้ผู้เล่นสลับช่องภาพให้ตรงกับภาพต้นฉบับ"
        case 2:
            datail.text = "จะต้องปาขวานให้โดนอ่างน้ำและฉลาม ตามภาพที่ได้เห็น"
        case 3:
            datail.text = "ผู้เล่นจะต้องจับคู่ภาพที่ตรงกันให้ได้มากที่สุดตามเวลาที่กำหนด"
        case 4:
            datail.text = "จับผิดภาพที่แตกต่างกันจากภาพที่ผู้ดูแลกำหนด จำนวน 5 จุด"
        default:
            datail.text = "คำอธิบายเกม"
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

