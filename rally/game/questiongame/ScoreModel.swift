//
//  QuestionGameViewController.swift
//  rally
//
//  Created by Jinyada on 12/2/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Firebase


class ScoreModel  {
    
        fileprivate var correctAnswers: Int = 0
        fileprivate var incorrectAnswers: Int = 0
        
    var s2:String="" //ประกาศเป็นสตริงเอาค่าเข้าไฟล์เบสแบบสตริง

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
        databaseRef.child("QuestionGame").childByAutoId().setValue(post) 
        

        if (percentaile > 0.75) {
            return "Score = \(correctAnswers)"
        }
        else if (percentaile > 0.5) {
            return "Score = \(correctAnswers)"
        }
        else {
             return "Score = \(correctAnswers)"
        }
    }
}




