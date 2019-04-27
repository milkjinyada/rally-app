//
//  Scan.swift
//  QR Code2
//
//  Created by Nisarat Mungjareon on 15/2/2562 BE.
//  Copyright © 2562 Nisarat Mungjareon. All rights reserved.
//


import UIKit
import AVFoundation
import FirebaseDatabase

internal extension Scanqr{
    
    @objc func didTapCancelButton() {
        //กดbutton Cancle ให้กดกลับมาหน้าก่อนหน้า
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "fristview") as! ViewController
        self.present(homeView, animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
}

class Scanqr: UIViewController {
    
    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    private let supportCode = [AVMetadataObject.ObjectType.qr]
    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")


    func AddMemberInRanking(roomname:String) {
       
        let RankRef  = Database.database().reference(withPath: "Ranking")
        RankRef.observe(.value, with:{ (snapshot: DataSnapshot) in
            for snap in snapshot.children {
                var room = (snap as! DataSnapshot).key
                
                if room == roomname
                {
                    
                    let ScoreItem : DatabaseReference! = Database.database().reference().child("Ranking").child(room).child("Group").child(ViewController.userEmail)
                    
                    let ScoreData: Dictionary<String,AnyObject> =
                        [   "Groupname" : ViewController.Groupname as AnyObject,
                            "AR" : Int(0) as AnyObject,
                            "Math" : Int(0) as AnyObject,
                            "Picture": Int(0) as AnyObject,
                            "Question": Int(0) as AnyObject,
                            "Run": Int(0) as AnyObject
                        ]
                    
                    let rankinggroup : DatabaseReference! = Database.database().reference().child("Ranking").child(room).child("Group")
                    
                    rankinggroup.observe(.value, with: { (snapshot: DataSnapshot) in
                        for snap in snapshot.children{
                            var user = (snap as! DataSnapshot).key
                            
                            if user == ViewController.userEmail{
                                return
                            }
                            
                        }
                        ScoreItem.setValue(ScoreData)//ส่งขึ้น firebase
                        
                        //เปลื่ยนสถานะของ User เป็น 2 = เข้าร่วมกิจกรรมแล้ว
                        let StatusItemRef = self.MemberRef.child("\(ViewController.userEmail!)/status")
                        StatusItemRef.setValue(2)//ส่งขึ้น firebase
                    })
                    
                   
                    
                }
                
            }})

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: screenSize.minX , y: 30, width: view.frame.size.width, height:  view.frame.size.height))

        self.view.addSubview(navBar);
        
        let navItem = UINavigationItem(title: "Scan QR Group");
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(Scanqr.didTapCancelButton));
        navItem.rightBarButtonItem = cancelItem;
        navBar.setItems([navItem], animated: false);
        navBar.tintColor = UIColor.black
        
        //Creating session
        let session = AVCaptureSession()
        
        //Define capture devcie
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)

        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = supportCode
        
        video = AVCaptureVideoPreviewLayer(session: session)
//      video.frame = view.layer.bounds
        video.frame = view.alignmentRect(forFrame: CGRect(x: 0 , y: 10, width: screenSize.width, height: screenSize.height))
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(square)
        
        session.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Scanqr: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if metadataObjects != nil && metadataObjects.count != 0{
        let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            
            //ถ้าสแกนแล้วมีค่า
            if supportCode.contains(object!.type) {
                if object!.stringValue != nil {
                    print(object!.stringValue!)//คือค่าที่สแกนได้
                    
                        let ChannelRef  = Database.database().reference(withPath: "Channel")
                        ChannelRef.observe(.value, with:{ (snapshot: DataSnapshot) in
                            for snap in snapshot.children {
                                var snapname = (snap as! DataSnapshot).key

                                //เช็คว่าค่าที่สแกนได้กับค่าใน DB ตรงกันไหม ถ้าตรงก็ไปหน้าถัดไป
                                if snapname == object!.stringValue!
                                    
                                {
                                    UserHomeViewController.Channelname = snapname
                                    let alert = UIAlertController(title: "Success", message: "Now you can join channel name \(snapname) . Do you want to join channel" , preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (nil) in
                                        
                                        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "fristview") as! ViewController
                                        self.present(homeView, animated: true, completion: nil)
                                        
                                    }))
                                    alert.addAction(UIAlertAction(title: "Join Channel", style: .default, handler: { (nil) in
                                        
                                        //เก็บ ชื่อห้องที่เข้าร่วม ขึ้น firebase
                                        
                                        let MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
                                        
                                        let SettingData: Dictionary<String,AnyObject> =
                                            ["Channel" : snapname as AnyObject]
                                        
                                        
                                        let ScoreItemRef = MemberRef.child("\(ViewController.userEmail!)")
                                        ScoreItemRef.updateChildValues(SettingData)//ส่งขึ้น firebase
                                        
                                        self.AddMemberInRanking(roomname: snapname)
                                        
                                        //ถ้าเข้าร่วมกลุ่ม  ให้เด้งไปหน้า UserHome
                                        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
                                        self.present(homeView, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                            }
                            //ถ้าไม่ตรงให้ขึ้น Alert
                            Const().ShowAlert(title: "Try Again", message: "ไม่พบกลุ่มที่คุณต้องการเข้าร่วม", viewContronller: self)
                        })
                }
            }
        }
    }
}
