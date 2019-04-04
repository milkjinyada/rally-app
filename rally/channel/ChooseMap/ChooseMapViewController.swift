import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class ChooseMapViewController: UIViewController {
    
     var ref = DatabaseReference.init()

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

            var lat : String
            var long : String
            lat = "".appendingFormat("%.8f", coordinate.latitude)
            long = "".appendingFormat("%.8f", coordinate.longitude)
            
            print(lat)
            print(long)
  
            //SAVE ตำแหน่งขึ้น Firebase
            let dict = ["name": "Kivy", "lat": lat,"long": long] as [String: Any]
            self?.ref.child("Location").childByAutoId().setValue(dict)

            })
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
        
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "gamesetting") as! GameSettingViewController
        self.present(homeView, animated: true, completion: nil)
    }
    
   
    

    
}

