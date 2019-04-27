//
//  QuestionGameViewController.swift
//  rally
//
//  Created by Jinyada on 12/2/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox
import Firebase
import FirebaseDatabase

class QuestionGameViewController: UIViewController {

    @IBOutlet weak var timerLebelQ: UILabel!
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var feedbackField: UILabel!
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var fourthChoiceButton: UIButton!
    @IBOutlet weak var nextQuestionButton: UIButton!
    
    var questions = QuestionModel()
    let score = ScoreModel()
    var timeout = updateTimer2
    
    
    //จำนวนคำถาม
    let numberOfQuestionPerRound = 10
    var currentQuestion: Question? = nil    
    var gameStartSound: SystemSoundID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        displayQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isGameOver() -> Bool {
        return score.getQuestionsAsked() >= numberOfQuestionPerRound
    }
    
    func displayQuestion() {
        currentQuestion = questions.getRandomQuestion()
        
        if let question = currentQuestion {
            let choices = question.getChoices()
            
            if (score.getQuestionsAsked() == 0){
                
                //start tinmer
                runTimer2()
            }
            
            
            questionField.text = question.getInterrogative()
            firstChoiceButton.setTitle(choices[0], for: .normal)
            secondChoiceButton.setTitle(choices[1], for: .normal)
            thirdChoiceButton.setTitle(choices[2], for: .normal)
            fourthChoiceButton.setTitle(choices[3], for: .normal)
            
            
            if (score.getQuestionsAsked() == numberOfQuestionPerRound - 1) {
                nextQuestionButton.setTitle("End Quiz", for: .normal)
            }
            else {
                nextQuestionButton.setTitle("Next Question", for: .normal)
            }
            
        }
        
        
        
        
        firstChoiceButton.isEnabled = true
        secondChoiceButton.isEnabled = true
        thirdChoiceButton.isEnabled = true
        fourthChoiceButton.isEnabled = true
        
        firstChoiceButton.isHidden = false
        secondChoiceButton.isHidden = false
        thirdChoiceButton.isHidden = false
        fourthChoiceButton.isHidden = false
        feedbackField.isHidden = true
        
        nextQuestionButton.isEnabled = false
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        if let question = currentQuestion, let answer = sender.titleLabel?.text,let Ans:String="" {
            
            if (question.validateAnswer(to: answer)) {
                score.incrementCorrectAnswers()
                feedbackField.textColor = UIColor(red:0.15, green:0.61, blue:0.61, alpha:1.0)
                feedbackField.text = "Correct! \n The Answer is \(question.AnswerQuestion(to: Ans))"
                
            } else {
                score.incrementIncorrectAnswers()
                feedbackField.textColor = UIColor(red:0.82, green:0.40, blue:0.26, alpha:1.0)
                feedbackField.text = "Sorry, that's not it. \n The Answer is \(question.AnswerQuestion(to: Ans))"
            }
            
            firstChoiceButton.isEnabled = false
            secondChoiceButton.isEnabled = false
            thirdChoiceButton.isEnabled = false
            fourthChoiceButton.isEnabled = false
            nextQuestionButton.isEnabled = true
            
            feedbackField.isHidden = false
        }
    }
    
    @IBAction func nextQuestionTapped(_ sender: Any) {
        if (isGameOver()) {
            displayScore()
        } else {
            displayQuestion()
        }
    }
    
    func displayScore() {
        questionField.text = score.getScore()
        score.reset()
        //รีเซ็ทเวลาเพื่อเริ่มเกมอีกครั้ง
        resetTimer2()
        score.getQuestionsAsked() == 15
        nextQuestionButton.setTitle("Play again", for: .normal)
        
        NextgameQuiz()
        
        feedbackField.isHidden = true
        firstChoiceButton.isHidden = true
        secondChoiceButton.isHidden = true
        thirdChoiceButton.isHidden = true
        fourthChoiceButton.isHidden = true
     
    }
    
    //เล่นเกมเสร็จขึ้นแจ้งเตือนให้กลับไปหน้าสแกนเริ่มเกมต่อไป
    func NextgameQuiz() {
        
        let alert = UIAlertController(title: "Success", message: "You got score:\(score.s2)!!" , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (nil) in
            
            //////ส่งคะแนนเกมขึ้น firebase
            let MemberRef : DatabaseReference! = Database.database().reference(withPath: "Ranking")
            let SettingData: Dictionary<String,AnyObject> = ["Question" : Int(self.score.s2) as AnyObject]
                let ScoreItemRef = MemberRef.child(UserHomeViewController.Channelname).child("Group").child(ViewController.Groupname).child(ViewController.userEmail)
           
            ScoreItemRef.updateChildValues(SettingData)//ส่งขึ้น firebase

            //กลับไปหน้า Home
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "usertabber") as! UserTabberViewController
            self.present(homeView, animated: true, completion: nil)
        
        }))
        present(alert, animated: true, completion: nil)
    }
    
  
    /////////////////  /////////////////  /////////////////  /////////////////
    //ตัวจับเวลา
    // MARK: - timer
    //to store how many sceonds the game is played for
    var seconds = 60 //เวลา
    
    //timer
    var timer2 = Timer()
    
    //to keep track of whether the timer is on
    var isTimerRunning = false
    
    //to run the timer
    func runTimer2() {
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer2)), userInfo: nil, repeats: true)
    }
    
    //decrements seconds by 1, updates the timerLabel and calls gameOver if seconds is 0
    @objc func updateTimer2() {
        if seconds == 0 {
            
            score.getQuestionsAsked() == 15
            timer2.invalidate()
            gameOver2()
        }else{
            seconds -= 1
            timerLebelQ.text = "\(seconds)"
        }
    }
    
    //resets the timer
    func resetTimer2(){
        timer2.invalidate()
        seconds = 60 //เวลา
        timerLebelQ.text = "\(seconds)"
    }
    
    // MARK: - game over
    
    func gameOver2(){
        displayScore()
        
        //ดึงค่าคะแนนจากฟังชั่นgetScore()ในหน้าScoreModel
        score.getScore()
    }
    
    /////////////////  /////////////////  /////////////////  /////////////////  /////////////////
    
    
}
