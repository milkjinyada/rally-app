//
//  RankScoree.swift
//  RankingScore
//
//  Created by Kievy on 11/4/2562 BE.
//  Copyright © 2562 Kievy. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class RankScoree {
    
    var Username: String?
    var gameSum: Int
    var photoUrl: String?
    var Email:String?
    
    init(Username: String, gameSum: Int, photoURL:String, Email:String) {
        self.Username = Username
        self.gameSum = gameSum
        self.photoUrl = photoURL
        self.Email = Email
    }
    
}
