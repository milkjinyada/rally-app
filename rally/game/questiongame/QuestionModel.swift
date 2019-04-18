//
//  QuestionModel.swift
//  QuizApp
//
//  Created by Samuel Yanez on 10/12/17.
//  Copyright © 2017 Samuel Yanez. All rights reserved.
//

import GameKit

struct QuestionModel {
    
    //คำถามมมมมม
    let questions = [
        Question(interrogative: "ต้นไม้ประจำมหาวิทยาลัย", answers: ["ต้นราชพฤกษ์", "ต้นชมพูพันทิพย์", "ต้นไทร", "ต้นจำปี"], correctAnswerIndex: 0),
        Question(interrogative: "ตรงวงเวียนหอสมุดมศว ประสานมิตร มีรูปปั้นของใครตั้งอยู่", answers: ["ศ.สาโรช บัวศรี ", "หม่อมหลวงปิ่น มาลากุล", "หม่อมหลวงไกรฤกษ์ เกษมสันต์", "จอมมารดาหม่อมหลวงปริก"], correctAnswerIndex: 1),
        Question(interrogative: "คณะที่เปิดสอนในระดับปริญญาตรีในปัจจุบันมีทั้งหมดกี่คณะ", answers: ["12 คณะ", "10 คณะ", "13 คณะ", "11 คณะ"], correctAnswerIndex: 0),
        Question(interrogative: "สีประจำมหาวิทยาลัย คือสีอะไร", answers: ["สีเทา-น้ำเงิน", "สีแดง-น้ำเงิน", "สีเทา-แดง", "สีแดง-น้ำตาล"], correctAnswerIndex: 2),
        Question(interrogative: "เราไม่สามารถใช้คมนาคมทางได้เพื่อเดินทางมา มศวได้", answers: ["รถรถไฟฟ้าใต้ดิน", "เฮลิคอปเตอร์", "เรือ", "ไม่มี"], correctAnswerIndex: 3),
        Question(interrogative: "มหาวิทยาลัยศรีนครินทรวิโรฒ มีความหมายว่าอะไร ", answers: ["เจริญเป็นศรีสง่าแก่เมืองทอง", "เจริญเป็นศรีสง่าแก่มหานคร", "เจริญเป็นศรีสง่าแก่แผ่นดินทอง", "เจริญเป็นศรีสง่าแห่งความรู้"], correctAnswerIndex: 1),
        Question(interrogative: "คำขวัญของ มศว คืออะไร", answers: ["การศึกษา คือ ความร่วมมือ", "การศึกษา คือ ความร่วมมือ", "การศึกษา คือ ความเจริญงอกงาม", "การศึกษา คือ ความเจริญงอกเงย"], correctAnswerIndex: 2),
        Question(interrogative: "มศว ไม่มีเกรดอะไร", answers: ["เกรด F", "เกรด E", "เกรด D", "เกรด C"], correctAnswerIndex: 0),
        Question(interrogative: "อัตลักษณ์นิสิตมศว มีกี่ข้อ", answers: ["9 ข้อ", "8 ข้อ", "7 ข้อ", "6 ข้อ"], correctAnswerIndex: 0),
        Question(interrogative: "ชื่อย่อของมหาวิทยาลัยศรีนครินทรวิโรฒ  คืออะไร", answers: ["ม.ศ.ว.", "มศว.", "ม.ศว", "มศว"], correctAnswerIndex: 3),
//        Question(interrogative: "ปัจจุบันมศว มีอายุกี่ปี", answers: ["60 ปี", "65 ปี","70 ปี", "75 ปี"], correctAnswerIndex: 2),
//        Question(interrogative: "ห้องพยาบาลมศว ประสานมิตรอยู่ตรงไหน", answers: ["ติดกับลานเล่นล้อ", "ข้างๆตึกคณะทันตแพทย์","อาคารบริการหม่อมหลวงปิ่น มาลากุล", "ตึกไข่ดาว"], correctAnswerIndex: 1),
//        Question(interrogative: "จุดเริ่มต้นของมหาวิทยาลัยศรีนครินทรวิโรฒมาจากที่ใด", answers: ["โรงเรียนฝึกหัดครูชั้นสูง", "โรงเรียนฝึกหัดครูพละศึกษา","โรงเรียนฝึกฝนวิชาชีพ", "โรงเรียนฝึกฝนครูชั้นสูง"], correctAnswerIndex: 0),
//         Question(interrogative: "อาคารนวัตกรรม ศาสตราจารย์ ดร.สาโรช บัวศรี มีชื่อเรียกอีกชื่อหนึ่งว่าอะไร", answers: ["ตึก 300 ล้าน", "ตึกไข่ดาว","ตึก 400 ล้าน", "ตึกประสานมิตร"], correctAnswerIndex: 2),
//         Question(interrogative: "ฟิตเนสที่มศว ประสานมิตร อยู่ที่ตึกไหน", answers: ["โรงยิม คณะพละศึกษา", "ลานเล่นล้อ","ใต้ตึกศิลปกรรม", "ชั้น2 ตึกไข่ดาว"], correctAnswerIndex: 3)
    ]
    
    var previouslyUsedNumbers: [Int] = []
    
    mutating func getRandomQuestion() -> Question {
        
        if (previouslyUsedNumbers.count == questions.count) {
            previouslyUsedNumbers = []
        }
        var randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        
        // Picks a new random number if the previous one has been used
        while (previouslyUsedNumbers.contains(randomNumber)) {
            randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        }
        previouslyUsedNumbers.append(randomNumber)
        
        return questions[randomNumber]
    }
}

class Question {
    
    fileprivate let interrogative: String
    fileprivate let answers: [String]
    fileprivate let correctAnswerIndex: Int
 
    
    
    init(interrogative: String, answers: [String], correctAnswerIndex: Int) {
        self.interrogative = interrogative
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
    }
    
    func correctAnswer() -> String {
        return answers[correctAnswerIndex]
    }
    
    
    func validateAnswer(to givenAnswer: String) -> Bool {
        return (givenAnswer == answers[correctAnswerIndex])
    }
    
    func getInterrogative() -> String {
        return interrogative
    }
    
    func getAnswer() -> String {
        return answers[correctAnswerIndex]
    }
    
    func getChoices() -> [String] {
        return answers
    }
    
    func getAnswerAt(index: Int) -> String {
        return answers[index]
    }
    
    func AnswerQuestion(to questionAns: String) -> String {
        return (answers[correctAnswerIndex])
    }
    

    
    
}

