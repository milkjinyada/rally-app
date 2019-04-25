//
//  CreateQR.swift
//  QR Code2
//
//  Created by Nisarat Mungjareon on 21/2/2562 BE.
//  Copyright © 2562 Nisarat Mungjareon. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class CreateQR: UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
       CreateQRCode()
    }
    
    
    var createqr: DatabaseReference!
    
    @IBOutlet weak var imageqr: UIImageView!
    
    //สร้าง QR CODE จากชื่อกลุ่ม
    func CreateQRCode(){

        let data = AdminHomeViewController.ChannelName.data(using: .ascii,allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        let ciImage = filter?.outputImage
        
        let transform = CGAffineTransform(scaleX: 10,y: 10)
        let transformImage = ciImage?.transformed(by: transform)
        
        let image = UIImage(ciImage: transformImage!)
        imageqr.image = image
        
    
    }
    
}
