//
//  ViewController.swift
//  Math test
//
//  Created by programming-xcode on 10/19/16.
//  Copyright © 2016 programming-xcode. All rights reserved.
//

import UIKit
import Firebase

class MathViewController: UIViewController {

    @IBOutlet var question: UILabel!
    @IBOutlet var ansField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var RightOrWrong: UILabel!
    @IBOutlet var NextProblem: UIButton!
    @IBOutlet var score: UILabel!
    @IBOutlet var timelabel: UILabel!
    @IBOutlet var options: UIButton!
    @IBOutlet var startbutton: UIButton!
    
    @IBOutlet var FinalScoreLabel: UILabel!
    
    
    var timeleft = Int(20)
    var scoremath = Int(0)
    var answer = Int()
    var number1 = Int()
    var number2 = Int()
    var sign = String()
    var signnum = Int()
    var timer = Timer()
    var scoretowin = Int(30)
    var pointspproblem = Int(1)
    
    var realTime:Int = 0
    
    var Finalscore = Int(0)
    
    var numberOfround = Int(1)
    
    var ref = DatabaseReference.init()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comedata()
        
        FinalScoreLabel.isHidden = true
        RightOrWrong.isHidden = true
        NextProblem.isHidden = true
        question.isHidden = true
        ansField.isHidden = true
        score.isHidden = true
        timelabel.isHidden = true
        submitButton.isHidden = true
        startbutton.isHidden = false
        options.isHidden = false
        NextProblem.setTitle("Next Problem", for: UIControl.State())
        //timeleft = UserDefaults.standard.integer(forKey: "totaltime")
        
         //let timer = Timer(timeInterval: 0.4, repeats: true) { _ in print("Done!") }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var GetData: DatabaseReference!
    
    func comedata(){
        
        GetData = Database.database().reference().child("OptionMath")
        GetData.observe(DataEventType.value, with: {(snapshot) in
            
            if snapshot.childrenCount>0{
                for myaccount in snapshot.children.allObjects as! [DataSnapshot]{
                    let myaccountObject = myaccount.value as? [String: AnyObject]
                    let Round = myaccountObject?["Round"] as? Int
                    let time = myaccountObject?["time"] as? Int
                    
                    var timeFIR = Int(time!)
                    var RoundFIR = Int(Round!)
                    
                    print(timeFIR)
                    
                    self.timeleft = timeFIR
                    self.scoretowin = RoundFIR
                    
                    self.realTime = timeFIR
                    
                    //self.timeleft = UserDefaults.standard.integer(forKey: "totaltime")
                    
                    
//                    let attraction = FIRData(timeFIR: timeFIR, ScoreOfproblemFIR: ScoreOfproblemFIR ,RoundFIR: RoundFIR)
//                    attraction.timeFIR = self.timeleft
//                    attraction.ScoreOfproblemFIR = self.pointspproblem
//                    attraction.RoundFIR = self.scoretowin
                    
                    
                    
                  
                }
                
                
            }
            
            
            
        })
    }
    
    @IBAction func start(_ sender: AnyObject) {
        RightOrWrong.isHidden = true
        NextProblem.isHidden = true
        options.isHidden = true
        startbutton.isHidden = true
        number1 = Int(arc4random_uniform(UInt32(50)))
        number2 = Int(arc4random_uniform(UInt32(50)))
        signnum = Int(arc4random_uniform(UInt32(3)))
        FinalScoreLabel.isHidden = false
        score.isHidden = false
        timelabel.isHidden = false
        score.text = "\(numberOfround)"
        switch signnum {
        case 0:
            sign = "+"
            answer = number1 + number2
            break
        case 1:
            sign = "-"
            answer = number1 - number2
            break
        case 2:
            sign = "x"
            answer = number1 * number2
            break
        default:
            break
        }
        question.text = "\(number1)\(sign)\(number2) = "
        question.isHidden = false
        ansField.isHidden = false
        submitButton.isHidden = false
        ansField.text = ""
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MathViewController.timeswitch), userInfo: nil, repeats: true)
    }
    
    func buttonTapped(){
        ansField.resignFirstResponder()
    }

    @IBAction func submit(_ sender: AnyObject) {
        question.isHidden = true
        ansField.isHidden = true
        submitButton.isHidden = true
        buttonTapped()
        
        if Int(ansField.text!) == answer {
            RightOrWrong.isHidden = false
            NextProblem.isHidden = false
            RightOrWrong.text = "Correct!"
            scoremath = scoremath + pointspproblem
            //score.text = "\(scoremath)"
            Finalscore = Finalscore + 1
            FinalScoreLabel.text = "\(Finalscore)"
       
            
        } else {
            RightOrWrong.isHidden = false
            NextProblem.isHidden = false
            RightOrWrong.text = "Incorrect!"
            scoremath = scoremath + pointspproblem
            //score.text = "\(scoremath)"
            Finalscore = Finalscore + 0
            FinalScoreLabel.text = "\(Finalscore)"

        }
        
        if scoremath >= scoretowin {
            question.isHidden = true
            ansField.isHidden = true
            submitButton.isHidden = true
            RightOrWrong.isHidden = false
            NextProblem.isHidden = false
            RightOrWrong.text = "You Win! :D :D :D"
            NextProblem.setTitle("Play Again", for: UIControl.State())
            NextgameMath()

        }
        
        timer.invalidate()
        timelabel.text = "\(timeleft)"
    }
    
    @IBAction func nextProb(_ sender: AnyObject) {
        if scoremath >= scoretowin {
            self.viewDidLoad()
        } else {
            question.isHidden = false
            ansField.isHidden = false
            submitButton.isHidden = false
            RightOrWrong.isHidden = true
            NextProblem.isHidden = true
            number1 = Int(arc4random_uniform(UInt32(50)))
            number2 = Int(arc4random_uniform(UInt32(50)))
            signnum = Int(arc4random_uniform(UInt32(3)))
            numberOfround = numberOfround + 1
            score.text = "\(numberOfround)"
            switch signnum {
            case 0:
                sign = "+"
                answer = number1 + number2
                break
            case 1:
                sign = "-"
                answer = number1 - number2
                break
            case 2:
                sign = "x"
                answer = number1 * number2
                break
            default:
                break
            }
            question.text = "\(number1)\(sign)\(number2) = "
            ansField.text = ""
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MathViewController.timeswitch), userInfo: nil, repeats: true)
            timeleft = realTime
            timelabel.text = "\(timeleft)"
        }
    }
    
    @objc func timeswitch() {
        timeleft = timeleft - 1
        timelabel.text = "\(timeleft)"
        if timeleft == 0 {
            timer.invalidate()
            question.isHidden = true
            ansField.isHidden = true
            submitButton.isHidden = true
            RightOrWrong.isHidden = false
            NextProblem.isHidden = false
            buttonTapped()
            RightOrWrong.text = "Time's Up!"
            scoremath = scoremath + pointspproblem
            //score.text = "\(scoremath)"
            Finalscore = Finalscore + 0
            FinalScoreLabel.text = "\(Finalscore)"
        }
        
        if scoremath >= scoretowin {
            question.isHidden = true
            ansField.isHidden = true
            submitButton.isHidden = true
            RightOrWrong.isHidden = false
            NextProblem.isHidden = false
            RightOrWrong.text = "You Win! :D :D :D"
            NextProblem.setTitle("Play Again", for: UIControl.State())
            NextgameMath()
        }
    }
    
    
    func NextgameMath() {
        
        let alert = UIAlertController(title: "Success", message: "You got score:\(Finalscore)!!" , preferredStyle: .alert)
        let scoreUploadMath = Finalscore
   
        
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (nil) in
            
            //////ส่งคะแนนเกมขึ้น firebase
            let MemberRef : DatabaseReference! = Database.database().reference(withPath: "Ranking")
            let SettingData: Dictionary<String,AnyObject> =
                ["Math" : Int(scoreUploadMath) as AnyObject]
            let ScoreItemRef = MemberRef.child(UserHomeViewController.Channelname).child("Group").child(ViewController.Groupname).child(ViewController.userEmail)
                ScoreItemRef.updateChildValues(SettingData)//ส่งขึ้น firebase
            
            //กลับไปหน้า  Home
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
            self.present(homeView, animated: true, completion: nil)
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
  
    
}

