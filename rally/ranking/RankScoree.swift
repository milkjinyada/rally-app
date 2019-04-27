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
    
    var Groupname: String?
    var gameSum: Int
    init(Groupname: String, gameSum: Int) {
        self.Groupname = Groupname
        self.gameSum = gameSum
    }
    
}
