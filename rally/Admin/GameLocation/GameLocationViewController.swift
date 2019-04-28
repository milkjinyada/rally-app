//
//  GameLocationViewController.swift
//  rally
//
//  Created by Jinyada on 28/4/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import MapKit
import SRAttractionsMap
import Firebase

class GameLocationViewController: UIViewController {

    var ref = DatabaseReference.init()
    var create: DatabaseReference!
    var arrData = [SRAttraction]()
    
    
    func fetch() {
        
        
        create = Database.database().reference().child("Member").child("\(ViewController.userEmail!)/channeldata/game")
        create.observe(DataEventType.value, with: {(snapshot) in
            
            print("snap")
            
            
            var snapshotArray: [DataSnapshot] = []
            
            for item in snapshot.children {
                
                snapshotArray.append(item as! DataSnapshot)
            }
            
            snapshotArray.reverse()
            
            
            var locationArray: [LocationFIR] = []
            
            for snap in snapshotArray {
                
                let locate = LocationFIR(dic: snap.value as! [String: Any])
                locationArray.append(locate)
            }
            
            
            for (index, locate) in locationArray.enumerated()  {
                
                
                let attractions = locationArray.enumerated().compactMap  { (index, locate) -> SRAttraction? in
                    
                    let latitude = Double(locate.lat)!
                    let longitude = Double(locate.long)!
                    
                    
                    let attraction = SRAttraction(latitude: latitude , longitude: longitude)
                    attraction.name = locate.title
                    attraction.subname = locate.subtitle
                    
                    
                    
                    return attraction
                    
                    
                }
                
                let mapVC = SRAttractionsMapViewController(attractions: attractions, displayMode: .allAttractions)
                mapVC.title = "Rally map"
                mapVC.calloutDetailButtonTitle = "View Description"
                
                let nVC = UINavigationController(rootViewController: mapVC)
                nVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .light),
                                                         NSAttributedString.Key.foregroundColor: UIColor.white]
                nVC.navigationBar.barTintColor = UIColor(red: 52.0/255.0, green: 52.0/255.0, blue: 52.0/255.0, alpha: 1.0)
                nVC.navigationBar.tintColor = UIColor.white
                nVC.navigationBar.isTranslucent = false
                self.present(nVC, animated: false, completion: nil)
                
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
}

class LocationFIR {
    
    var title: String = ""
    var subtitle: String = ""
    var lat: String = ""
    var long: String = ""
    
    init(dic: [String: Any]) {
        
        self.title = dic["name"] as? String ?? ""
        self.subtitle = dic["Description"] as? String ?? ""
        self.lat = dic["lat"] as? String ?? ""
        self.long = dic["long"] as? String ?? ""
    }
}
