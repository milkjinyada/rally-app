//
//  ARHacheGameViewController.swift
//  rally
//
//  Created by Jinyada on 12/2/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import FirebaseDatabase


class ARHacheGameViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    //MARK: - variables
    
    @IBOutlet var sceneView: ARSCNView!
    
    //used to display timer to player
    @IBOutlet weak var timerLabel: UILabel!
    
    //used to display score to player
    @IBOutlet weak var scoreLabel: UILabel!
    
    //used to store the score
    var score = 0
    
    //MARK: - buttons
    
    //axe button
    @IBAction func onAxeButton(_ sender: Any) {
        fireMissile(type: "axe")
    }
    
    //banana button
    //    @IBAction func onBananaButton(_ sender: Any) {
    //        fireMissile(type: "banana")
    //    }
    
    //MARK: - maths
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    //MARK: - view functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        //set the physics delegate
        sceneView.scene.physicsWorld.contactDelegate = self
        
        //add objects to shoot at
        addTargetNodes()
        
        //play background music
        playBackgroundMusic()
        
        //start tinmer
        runTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - timer
    
    //to store how many sceonds the game is played for
    var seconds = 41
    
    //timer
    var timer = Timer()
    
    //to keep track of whether the timer is on
    var isTimerRunning = false
    
    //to run the timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    //decrements seconds by 1, updates the timerLabel and calls gameOver if seconds is 0
    @objc func updateTimer() {
        if seconds == 0 {
            timer.invalidate()
            gameOver()
        }else{
            seconds -= 1
            timerLabel.text = "\(seconds)"
        }
    }
    
    //resets the timer
    func resetTimer(){
        timer.invalidate()
        seconds = 41
        timerLabel.text = "\(seconds)"
    }
    
    // MARK: - game over
    var realscore : Int = 0 //คะแนนที่เกิดจากการตัดให้เต็ม 10 คะแนน
    func gameOver(){

        let defaults = UserDefaults.standard
                let GameS = defaults.value(forKey: "score")
                let score = GameS as! Int //รับค่าคะแนนในเกมมาจากหน้า viewcontroller
        
                //let S = GameS as! Int!
        
                //เอาคะแนนในเกมมาคิด ทุกๆ 10 คะแนน= 1 คะแนน
                if (score > 0 && score <= 9) {
                    realscore = 0
                }
                else if (score >= 10 && score <= 19) {
                    realscore = 1
                }
                else if (score >= 20 && score <= 29) {
                    realscore = 2
                }
                else if (score >= 30 && score <= 39) {
                    realscore = 3
                }
                else if (score >= 40 && score <= 49) {
                    realscore = 4
                }
                else if (score >= 50 && score <= 59) {
                    realscore = 5
                }
                else if (score >= 60 && score <= 69) {
                    realscore = 6
                }
                else if (score >= 70 && score <= 79) {
                    realscore = 7
                }
                else if (score >= 80 && score <= 89) {
                    realscore = 8
                }
                else if (score >= 90 && score <= 100) {
                    realscore = 9
                }
                else {
                    realscore = 10
                }
        
                let alert = UIAlertController(title: "Success", message: "You got score = \(String(score)) คะแนน (ทุก 10 คะแนนคิดเป็น 1 คะแนน) = \(realscore) คะแนน" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (nil) in
        
        
                    //เมื่อกดปุ่มเอลิทจะเอาคะแนนที่ถูกหารแล้วเข้า firebase
                    let Name_ = self.realscore
                    let post : [String: AnyObject] = ["Score" : Name_ as AnyObject]
                    let databaseRef = Database.database().reference()
                    databaseRef.child("ARScore").childByAutoId().setValue(post) //หัวข้อชื่อ Posts
        
        
                    //ถ้าเข้าร่วมกลุ่ม  ให้เด้งไปหน้า Nextpage
                    //(withIdentifier: "next") ใส่ตรง StorybordID ของหน้าที่ต้องการให้เด้งไปนะจ๊ะ
                    let homeView = self.storyboard?.instantiateViewController(withIdentifier: "userhomeview") as! UserHomeViewController
                    self.present(homeView, animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
    }
    
    // MARK: - missiles & targets
    
    //creates banana or axe node and 'fires' it
    func fireMissile(type : String){
        var node = SCNNode()
        //create node
        node = createMissile(type: type)
        
        //get the users position and direction
        let (direction, position) = self.getUserVector()
        node.position = position
        var nodeDirection = SCNVector3()
        switch type {
        case "banana":
            nodeDirection  = SCNVector3(direction.x*4,direction.y*4,direction.z*4)
            node.physicsBody?.applyForce(nodeDirection, at: SCNVector3(0.1,0,0), asImpulse: true)
//            playSound(sound: "monkey", format: "mp3")
        case "axe":
            nodeDirection  = SCNVector3(direction.x*4,direction.y*4,direction.z*4)
            node.physicsBody?.applyForce(SCNVector3(direction.x,direction.y,direction.z), at: SCNVector3(0,0,0.1), asImpulse: true)
//            playSound(sound: "rooster", format: "mp3")
        default:
            nodeDirection = direction
        }
        
        //move node
        node.physicsBody?.applyForce(nodeDirection , asImpulse: true)
        
        //add node to scene
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    //creates nodes
    func createMissile(type : String)->SCNNode{
        var node = SCNNode()
        
        //using case statement to allow variations of scale and rotations
        switch type {
        case "banana":
            let scene = SCNScene(named: "art.scnassets/banana.dae")
            node = (scene?.rootNode.childNode(withName: "Cube_001", recursively: true)!)!
            node.scale = SCNVector3(0.2,0.2,0.2)
            node.name = "banana"
        case "axe":
            let scene = SCNScene(named: "art.scnassets/axe.dae")
            node = (scene?.rootNode.childNode(withName: "axe", recursively: true)!)!
            node.scale = SCNVector3(0.3,0.3,0.3)
            node.name = "bathtub"
        default:
            node = SCNNode()
        }
        
        //the physics body governs how the object interacts with other objects and its environment
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        
        //these bitmasks used to define "collisions" with other objects
        node.physicsBody?.categoryBitMask = CollisionCategory.missileCategory.rawValue
        node.physicsBody?.collisionBitMask = CollisionCategory.targetCategory.rawValue
        return node
}

    //Adds 100 objects to the scene, spins them, and places them at random positions around the player.
    func addTargetNodes(){
        for index in 1...100 {
            
            var node = SCNNode()
            
            if (index > 9) && (index % 10 == 0) {
                let scene = SCNScene(named: "art.scnassets/mouthshark.dae")
                node = (scene?.rootNode.childNode(withName: "shark", recursively: true)!)!
                node.scale = SCNVector3(0.3,0.3,0.3)
                node.name = "shark"
            }else{
                let scene = SCNScene(named: "art.scnassets/bath.dae")
                node = (scene?.rootNode.childNode(withName: "Cube_001", recursively: true)!)!
                node.scale = SCNVector3(0.02,0.02,0.02)
                node.name = "bath"
            }
            
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.physicsBody?.isAffectedByGravity = false
            
            //place randomly, within thresholds
            node.position = SCNVector3(randomFloat(min: -10, max: 10),randomFloat(min: -4, max: 5),randomFloat(min: -10, max: 10))
            
            //rotate
            let action : SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 1.0)
            let forever = SCNAction.repeatForever(action)
            node.runAction(forever)
            
            //for the collision detection
            node.physicsBody?.categoryBitMask = CollisionCategory.targetCategory.rawValue
            node.physicsBody?.contactTestBitMask = CollisionCategory.missileCategory.rawValue
            
            //add to scene
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    //create random float between specified ranges
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    
    // MARK: - Contact Delegate
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        print("** Collision!! " + contact.nodeA.name! + " hit " + contact.nodeB.name!)
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.targetCategory.rawValue
            || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.targetCategory.rawValue {
            
            if (contact.nodeA.name! == "shark" || contact.nodeB.name! == "shark") {
                score+=5
            }else{
                score+=1
            }
            
            DispatchQueue.main.async {
                contact.nodeA.removeFromParentNode()
                contact.nodeB.removeFromParentNode()
                self.scoreLabel.text = String(self.score)
            }
            

        }
    }
    
    // MARK: - sounds
    
    var player: AVAudioPlayer?

    
    func playBackgroundMusic(){
        let audioNode = SCNNode()
        let audioSource = SCNAudioSource(fileNamed: "overtake.mp3")!
        let audioPlayer = SCNAudioPlayer(source: audioSource)
        
        audioNode.addAudioPlayer(audioPlayer)
        
        let play = SCNAction.playAudio(audioSource, waitForCompletion: true)
        audioNode.runAction(play)
        sceneView.scene.rootNode.addChildNode(audioNode)
    }
    
}

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let missileCategory  = CollisionCategory(rawValue: 1 << 0)
    static let targetCategory = CollisionCategory(rawValue: 1 << 1)
    static let otherCategory = CollisionCategory(rawValue: 1 << 2)
}
