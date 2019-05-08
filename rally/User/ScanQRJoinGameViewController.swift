//
//  ScanQRJoinGameViewController.swift
//  rally
//
//  Created by Jinyada on 9/5/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

internal extension  ScanQRJoinGame{
    
    @objc func didTapCancelButton() {
        //กดbutton Cancle ให้กดกลับมาหน้าก่อนหน้า
        let MemberVc = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
        self.present(MemberVc, animated: true, completion: nil)
    }
}

class ScanQRJoinGame: UIViewController {
    
    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    private let supportCode = [AVMetadataObject.ObjectType.qr]
    var MemberRef : DatabaseReference! = Database.database().reference(withPath: "Member")
    

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
        
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension  ScanQRJoinGame: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects != nil && metadataObjects.count != 0{
            let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            //ถ้าสแกนแล้วมีค่า
            if supportCode.contains(object!.type) {
                if object!.stringValue != nil {
                    var gamename:String = ""
                   
                    switch object!.stringValue {
                    case "เกมถามตอบ":
                        gamename = "QuizGame"

                        let alert = UIAlertController(title: "Success", message: "Now you can join game \(gamename) . Do you want to join Game?" , preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Join Game", style: .default, handler: { (nil) in
                            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "question") as! QuestionView
                            self.present(GameVC, animated: true, completion: nil)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (nil) in
                            
                            let MemberVc = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
                            self.present(MemberVc, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    case "เกมสลับภาพ":
                        gamename = "Silde Photo"
                        let alert = UIAlertController(title: "Success", message: "Now you can join game \(gamename) . Do you want to join Game?" , preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Join Game", style: .default, handler: { (nil) in
                            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "picscrolling") as! PicScrollingView
                            self.present(GameVC, animated: true, completion: nil)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (nil) in
                            
                            let MemberVc = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
                            self.present(MemberVc, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                       
                    case "เกมปาขวาน":
                        gamename = "Aim and Shoot"
                        let alert = UIAlertController(title: "Success", message: "Now you can join game \(gamename) . Do you want to join Game?" , preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Join Game", style: .default, handler: { (nil) in
                            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "ARHache") as! ARHacheGameView
                            self.present(GameVC, animated: true, completion: nil)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (nil) in
                            
                            let MemberVc = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
                            self.present(MemberVc, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                      
                        
                    case "เกมเดินให้ดี":
                        gamename = "Beware your step"
                        let alert = UIAlertController(title: "Success", message: "Now you can join game \(gamename) . Do you want to join Game?" , preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Join Game", style: .default, handler: { (nil) in
                            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "run") as! RunGameView
                            self.present(GameVC, animated: true, completion: nil)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (nil) in
                            
                            let MemberVc = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
                            self.present(MemberVc, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    
                        
                    case "เกมบวกเลข":
                        gamename = "Math test"
                        let alert = UIAlertController(title: "Success", message: "Now you can join game \(gamename) . Do you want to join Game?" , preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Join Game", style: .default, handler: { (nil) in
                            let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "math") as! MathGameView
                            self.present(GameVC, animated: true, completion: nil)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (nil) in
                            
                            let MemberVc = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
                            self.present(MemberVc, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                       
                        
                    default:
                        //ถ้าไม่ตรงให้ขึ้น Alert
                        Const().ShowAlert(title: "Try Again", message: "ไม่พบกลุ่มที่คุณต้องการเข้าร่วม", viewContronller: self)
                    }
                }
            }
        }
    }
}
