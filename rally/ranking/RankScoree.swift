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
        
    var name: String?
    var gameSum: Int
    init(name: String, gameSum: Int) {
        self.name = name
        self.gameSum = gameSum    
    }

}
