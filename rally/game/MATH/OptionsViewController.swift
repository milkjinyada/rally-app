//
//  OptionsViewController.swift
//  Math test
//
//  Created by programming-xcode on 10/19/16.
//  Copyright © 2016 programming-xcode. All rights reserved.
//

import UIKit
import Firebase

class OptionsViewController: UIViewController {
    
    @IBOutlet var timelabel: UILabel!
    
   
    //@IBOutlet var scorepproblemlabel: UILabel!
    @IBOutlet var scoretowinlabel: UILabel!
    var pperprob = Int(0)
    var scoretowin = Int(0)
    var time = Int(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        timelabel.text = "\(time)"
 
        scoretowinlabel.text = "\(scoretowin)"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveOptions(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "saveoptions", sender: self)
        
        let ref = Database.database().reference().child("OptionMath")
        ref.childByAutoId().setValue(["time": time ,"Round": scoretowin])
        
    }
    
    @IBAction func timestepper(_ stepper: UIStepper) {
        let stepperval = stepper.value
        time = Int(stepperval)
        timelabel.text = "\( time )"
    }
    


    
    @IBAction func scoretowinstepper(_ stepper: UIStepper) {
        let stepperval = stepper.value
        scoretowin = Int(stepperval)
        scoretowinlabel.text = "\(scoretowin)"
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "saveoptions" {
//            var destination = segue.destination as! ViewController
//            destination.timeleft = time
//            destination.scoretowin = scoretowin
//            destination.pointspproblem = pperprob
//            UserDefaults.standard.set(time, forKey: "totaltime")
//        }
//    }
//    

}
