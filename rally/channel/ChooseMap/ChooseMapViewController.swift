//
//  ViewController.swift
//  LocationPickerController
//
//  Created by koogawa on 2016/04/30.
//  Copyright © 2016 koogawa. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class ChooseMapViewController: UIViewController {
    
     var ref = DatabaseReference.init()


    @IBOutlet weak var locationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapSelectLocationButton(_ sender: AnyObject) {
        let viewController = LocationPickerController(success: {
            [weak self] (coordinate: CLLocationCoordinate2D) -> Void in
//            self?.locationLabel.text = "".appendingFormat("%.6f, %.6f",
//                coordinate.latitude, coordinate.longitude)
            
            var lat : String
            var long : String
            lat = "".appendingFormat("%.8f", coordinate.latitude)
            long = "".appendingFormat("%.8f", coordinate.longitude)
            print(lat)
            print(long)
            
            //self!.saveFIRData()
            
            let dict = ["name": "Kivy", "lat": lat,"long": long] as [String: Any]
            self?.ref.child("Location").childByAutoId().setValue(dict)
           

            
            
            })
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
   
    

    
}

