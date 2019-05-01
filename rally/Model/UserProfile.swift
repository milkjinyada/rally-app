//
//  ImageService.swift
//  rally
//
//  Created by Jinyada on 29/4/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import Foundation

class UserProfile {
    var uid:String
    var username:String
    var photoURL:URL
    
    init(uid:String, username:String,photoURL:URL) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}

