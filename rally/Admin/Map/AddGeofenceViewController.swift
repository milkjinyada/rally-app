

//  Created by Sumeet on 3/18/19.
//  Copyright © 2019 Sumeet. All rights reserved.
//



import UIKit
import MapKit

protocol AddGeofenceViewControllerDelegate {
    func addGeotificationViewController(_ controller: AddGeofenceViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,radius: Double, identifier: String, note: String, eventType: Geotification.EventType)
    
    //เพิ่มฟังชั่นส่งค่าไปหน้าสอง
    //    func sendDataToFirstViewController(myData: [String])
    
}

class AddGeofenceViewController: UITableViewController {
    
    static var lat: String = ""
    static var long: String = ""
    static var radiusString: String = ""
    static var identifierString: String = ""
    static var noteString: String = ""
    static var eventTypeString: String = ""
    //var choosegamevc: ChooseGameViewController
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var zoomButton: UIBarButtonItem!
    @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: AddGeofenceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [addButton, zoomButton]
        addButton.isEnabled = false
        
        
        //ทำให้คีบร์อดที่ขึ้นมาหายไป
        let tab:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddGeofenceViewController.dismiskeyboard)) //เรียกใช้ฟังชั่น dismiskeyboard
        view.addGestureRecognizer(tab) //เวลา tab(กดพื้นที่อื่น) คีบร์อดจะหายไป
    }
    
    //ฟังชั่นเอาคีร์บอร์ดออก
    @objc func dismiskeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        addButton.isEnabled = !radiusTextField.text!.isEmpty && !noteTextField.text!.isEmpty
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func onAdd(sender: AnyObject) {
        
        
        let coordinate = mapView.centerCoordinate
        let radius = Double(radiusTextField.text!) ?? 0
        let identifier = NSUUID().uuidString
        let note = noteTextField.text
        let eventType: Geotification.EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
        delegate?.addGeotificationViewController(self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: eventType)
        
        AddGeofenceViewController.lat = String(coordinate.latitude)
        AddGeofenceViewController.long = String(coordinate.longitude)
        AddGeofenceViewController.radiusString = String(radius)
        AddGeofenceViewController.identifierString = String(identifier)
        AddGeofenceViewController.noteString = String(note!)
        AddGeofenceViewController.eventTypeString = eventType.rawValue
        
        print("lat= \(AddGeofenceViewController.lat)")
        print("long= \(AddGeofenceViewController.long)")
        print("radiusString= \(AddGeofenceViewController.radiusString)")
        print("identifierString= \(AddGeofenceViewController.identifierString)")
        print("noteString= \(AddGeofenceViewController.noteString)")
        print("eventTypeString= \(AddGeofenceViewController.eventTypeString)")
        
        ChooseGameViewController.counter = true
        
        
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "ChooseGame") as! UIViewController
        self.present(homeView, animated: true, completion: nil)
        
        
        //    //ส่งค่าไปหน้า2
        //    if self.delegate != nil {
        //        let dataToBeSent = [lat,long,radiusString,identifierString, noteString, eventTypeString]
        //        print("ปริ้นส่งค่าไปหน้าแรก = \(dataToBeSent)")
        //        self.delegate?.sendDataToFirstViewController(myData:dataToBeSent)
        //        dismiss(animated: true, completion: nil)
        //
        //
        //    }
        
    }
    
    
    
    @IBAction private func onZoomToCurrentLocation(sender: AnyObject) {
        mapView.zoomToUserLocation()
    }
}
