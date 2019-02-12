//
//  ScoreModel.swift
//  QuizApp
//
//  Created by Samuel Yanez on 10/12/17.
//  Copyright © 2017 Samuel Yanez. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Firebase


class ScoreModel  {
    
        fileprivate var correctAnswers: Int = 0
        fileprivate var incorrectAnswers: Int = 0
    
    
    var s2:String="" //ประกาศเป็นสตริงเอาค่าเข้าไฟล์เบสแบบสตริง

  
    //var lastscore:String=""
    
    func reset() {
        correctAnswers = 0
        incorrectAnswers = 0
    }

    func incrementCorrectAnswers() {
        correctAnswers += 1
        s2=String(correctAnswers) //เอาcorrectAnswers(ค่าคะแนน)มาใส่ใน S2 และทำให้เป็นสตริง
    }
    
    func incrementIncorrectAnswers() {
        incorrectAnswers += 1
    }

    
    func getQuestionsAsked() -> Int {
        return correctAnswers + incorrectAnswers
        
    }
    
   
  
    func getScore() -> String {
        let percentaile = Double(correctAnswers) / Double(getQuestionsAsked())

        //เอาคะแนนเข้า firebase
        let Name_ = s2
        let post : [String: AnyObject] = ["Score" : Name_ as AnyObject]
        let databaseRef = Database.database().reference()
        databaseRef.child("Posts").childByAutoId().setValue(post) //หัวข้อชื่อ Posts
        

        if (percentaile > 0.75) {
            return "ทำคะแนนได้ดี\n You got \(correctAnswers) out of 15 correct answers!"
            
            
        }
        else if (percentaile > 0.5) {
            return "เยี่ยมม\n You got \(correctAnswers) out of 15 correct answers!"

        }
        else {
            return "พยายามกว่านี้อีก\n You got \(correctAnswers) out of 15 correct answers!"
        }
  
    }
    

//ส่งค่าข้ามหน้าโดยใช้สาย ให้สายชื่อpassData
//    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "passData" {
//            let score1 = segue.destination as! File
//            score1.lastscore = String(correctAnswers)
//
//        }
//    }
    
    
}




