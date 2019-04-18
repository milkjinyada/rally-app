//
//  HomeViewController.swift
//  AR Madness
//
//  Created by O'Sullivan, Andy on 30/05/2018.
//  Copyright © 2018 O'Sullivan, Andy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ARHacheGameHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  
    @IBAction func onPlayButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToGameSegue", sender: self)
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
