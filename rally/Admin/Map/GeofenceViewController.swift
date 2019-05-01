

//  Created by Sumeet on 3/18/19.
//  Copyright © 2019 Sumeet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

class GeofenceViewController: UIViewController {
    
    var ref = DatabaseReference.init()
    var create: DatabaseReference!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var geotifications: [Geotification] = []
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        loadAllGeotifications()
        getAllFIRData()
        //fetch()
        
    }
    
    //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    if segue.identifier == "addGeotification" {
    //      let navigationController = segue.destination as! UINavigationController
    //      let vc = navigationController.viewControllers.first as! AddGeofenceViewController
    //      vc.delegate = self
    //    }
    
    //  }
    
    
    func getAllFIRData() {
        
        
        //            let databaseRef = Database.database().reference()
        ////            databaseRef.child("Member").child("\(AdminHomeViewController.ChannelName)").queryOrdered(byChild:"Group").observeSingleEvent(of: .value, with: { snapshot in
        //            databaseRef.child("Member").child("admintest3@gmaildotcom/channeldata/game").queryOrdered(byChild:"Group").observeSingleEvent(of: .value, with: { snapshot in
        
        self.create = Database.database().reference().child("Member").child("\(ViewController.userEmail!)/channeldata/game")
        self.create.observe(DataEventType.value, with: {(snapshot) in
            //self.arrData.removeAll()
            if let snapShort = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapShort{
                    if let mainDict = snap.value as? [String: AnyObject]{
                        //                                    let  Groupname = mainDict["Groupname"] as? String
                        //                                    let  Picture = mainDict["Picture"] as? Int
                        //                                    let  Math = mainDict["Math"] as? Int
                        //                                    let  Run = mainDict["Run"] as? Int
                        //                                    let  AR = mainDict["AR"] as? Int
                        //                                    let  Question = mainDict["Question"] as? Int
                        
                        let latitude = Double(mainDict["latitude"] as! String)
                        let longitude = Double(mainDict["longitude"] as! String)
                        let note = mainDict["note"] as? String
                        let radius = Double(mainDict["radius"] as! String)
                        let identifier = mainDict["identifier"] as? String
                        let eventType = mainDict["eventType"] as? String
                        let gamename = mainDict["gamename"] as? String
                        
                        let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                        let clampedRadius = min(radius!, self.locationManager.maximumRegionMonitoringDistance)
                        let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier!, note: note!, eventType: Geotification.EventType(rawValue: eventType!)!)
                        self.add(geotification)
                        self.startMonitoring(geotification: geotification)
                        self.saveAllGeotifications()
                        
                        print(latitude!)
                        
                        //self.arrData.append(RankScoree(Groupname: Groupname!, gameSum: gameSum))
                        
                        //                                    DispatchQueue.main.async {
                        //                                        self.tableView.reloadData()
                        //                                    }
                    }
                }
            }
        })
        
        //})
        
        
        
        
        
    }
    
    //    func fetch() {
    //
    //
    //        //create = Database.database().reference().child("Member").child("\(ViewController.userEmail!)/channeldata/game")
    //        create = Database.database().reference().child("Member").child("admintest3@gmaildotcom/channeldata/game")
    //        create.observe(DataEventType.value, with: {(snapshot) in
    //
    //            print("snap")
    //
    //
    //            var snapshotArray: [DataSnapshot] = []
    //
    //            for item in snapshot.children {
    //
    //                snapshotArray.append(item as! DataSnapshot)
    //            }
    //
    //            snapshotArray.reverse()
    //
    //
    //            var locationArray: [LocationFIR] = []
    //
    //            for snap in snapshotArray {
    //
    //                let locate = LocationFIR(dic: snap.value as! [String: Any])
    //                locationArray.append(locate)
    //            }
    //
    //            for (index, locate) in locationArray.enumerated()  {
    //
    //
    //                let attractions = locationArray.enumerated().compactMap  { (index, locate) in
    //
    //                    let latitude = Double(locate.latitude)!
    //                    let longitude = Double(locate.longitude)!
    //                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    //                    let note = String(locate.note)
    //                    let radius = Double(locate.radius)!
    //                    let identifier = String(locate.identifier)
    //                    let eventType = String(locate.eventType)
    //
    //
    //
    //                    //                    let attraction = SRAttraction(latitude: Latitude , longitude: Longitude)
    //                    //                    attraction.name = locate.title
    //                    //                    attraction.subname = locate.subtitle
    //                    //
    //
    //
    //                    //return attraction
    //
    //
    //                }
    //                func addGeotificationViewController(_ controller: AddGeofenceViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: Geotification.EventType) {
    //                    controller.dismiss(animated: true, completion: nil)
    //                    let clampedRadius = min(radius, self.locationManager.maximumRegionMonitoringDistance)
    //                    let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
    //                    self.add(geotification)
    //                    self.startMonitoring(geotification: geotification)
    //                    self.saveAllGeotifications()
    //                }
    //            }
    //
    //        })
    //    }
    
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        geotifications.removeAll()
        let allGeotifications = Geotification.allGeotifications()
        allGeotifications.forEach { add($0) }
    }
    
    func saveAllGeotifications() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(geotifications)
            UserDefaults.standard.set(data, forKey: PreferencesKeys.savedItems)
        } catch {
            print("error encoding geotifications")
        }
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    func add(_ geotification: Geotification) {
        geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        addRadiusOverlay(forGeotification: geotification)
        //updateGeotificationsCount()
    }
    
    //  func remove(_ geotification: Geotification) {
    //    guard let index = geotifications.index(of: geotification) else { return }
    //    geotifications.remove(at: index)
    //    mapView.removeAnnotation(geotification)
    //    removeRadiusOverlay(forGeotification: geotification)
    //    updateGeotificationsCount()
    //  }
    
    //func updateGeotificationsCount() {
    //title = "Rally Map"
    //title = "Geotifications: \(geotifications.count)"
    //navigationItem.rightBarButtonItem?.isEnabled = (geotifications.count < 20)
    //}
    
    // MARK: Map overlay functions
    func addRadiusOverlay(forGeotification geotification: Geotification) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlay(forGeotification geotification: Geotification) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    // MARK: Other mapview functions
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        mapView.zoomToUserLocation()
    }
    
    func region(with geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            let message = """
      Your geotification is saved but will only be activated once you grant
      Geotify permission to access the device location.
      """
            showAlert(withTitle:"Warning", message: message)
        }
        
        let fenceRegion = region(with: geotification)
        locationManager.startMonitoring(for: fenceRegion)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
}

// MARK: - Location Manager Delegate
extension GeofenceViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = status == .authorizedAlways
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
}

// MARK: - MapView Delegate
extension GeofenceViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeotification"
        if annotation is Geotification {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                //        let removeButton = UIButton(type: .custom)
                //        removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                //        removeButton.setImage(UIImage(named: "DeleteGeotification")!, for: .normal)
                //        annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    //  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //    // Delete geotification
    //    let geotification = view.annotation as! Geotification
    //    remove(geotification)
    //    saveAllGeotifications()
    //  }
    
    
    
}

// MARK: AddGeotificationViewControllerDelegate
extension GeofenceViewController: AddGeofenceViewControllerDelegate {
    //    func sendDataToFirstViewController(myData: [String]) {
    //
    //    }
    
    
    func addGeotificationViewController(_ controller: AddGeofenceViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: Geotification.EventType) {
        controller.dismiss(animated: true, completion: nil)
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
        add(geotification)
        startMonitoring(geotification: geotification)
        saveAllGeotifications()
        
    }
    
}

//class LocationFIR {
//
//    var note: String = ""
//    var radius: String = ""
//    var latitude: String = ""
//    var longitude: String = ""
//    var identifier: String = ""
//    var eventType: String = ""
//    var gamename: String = ""
//
//
//    init(dic: [String: Any]) {
//
//        self.latitude = dic["latitude"] as? String ?? ""
//        self.longitude = dic["longitude"] as? String ?? ""
//        self.note = dic["note"] as? String ?? ""
//        self.radius = dic["radius"] as? String ?? ""
//        self.identifier = dic["identifier"] as? String ?? ""
//        self.eventType = dic["eventType"] as? String ?? ""
//        self.gamename = dic["gamename"] as? String ?? ""
//    }
//}

extension Geotification {
    public class func allGeotifications() -> [Geotification] {
        guard let savedData = UserDefaults.standard.data(forKey: PreferencesKeys.savedItems) else { return [] }
        let decoder = JSONDecoder()
        if let savedGeotifications = try? decoder.decode(Array.self, from: savedData) as [Geotification] {
            return savedGeotifications
        }
        return []
    }
}
