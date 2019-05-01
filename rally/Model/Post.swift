//
//  ImageService.swift
//  rally
//
//  Created by Jinyada on 29/4/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import Foundation


class Post {
    var id:String
    var author:UserProfile
    var text:String
    var createdAt:Date
    
    init(id:String, author:UserProfile,text:String,timestamp:Double) {
        self.id = id
        self.author = author
        self.text = text
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
    }
}
