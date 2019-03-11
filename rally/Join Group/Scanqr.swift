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

class Scanqr: UIViewController {
    
    
    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    
    private let supportCode = [AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        video.frame = view.layer.bounds
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
                                    
                                    let alert = UIAlertController(title: "Success", message: "Now you can join channel name \(snapname) . Do you want to join channel" , preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (nil) in
                                        
                                        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "fristview") as! ViewController
                                        self.present(homeView, animated: true, completion: nil)
                                        
                                    }))
                                    alert.addAction(UIAlertAction(title: "Join Channel", style: .default, handler: { (nil) in
                                        
                                        //ถ้าเข้าร่วมกลุ่ม  ให้เด้งไปหน้า Nextpage
                                        //(withIdentifier: "next") ใส่ตรง StorybordID ของหน้าที่ต้องการให้เด้งไปนะจ๊ะ
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
































//ถ่าย QR แล้วขึ้นเอลิท อันเก่า

//func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//
//    //        func captureOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [Any], from connection: AVCaptureConnection) {
//    print("2222")
//
//    if metadataObjects != nil && metadataObjects.count != 0
//    {
//        if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
//        {
//            if supportCode.contains(object.type)
//                //                if object.type == AVMetadataObject.ObjectType
//            {
//                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
//                alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
//                    UIPasteboard.general.string = object.stringValue
//
//                    //ปริ๊นคำที่ถ่ายออกมา
//                    print(object.stringValue)
//                }))
//
//                present(alert, animated: true, completion: nil)
//            }
//        }
//    }
//}
//
