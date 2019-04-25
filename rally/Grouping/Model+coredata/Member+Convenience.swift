
//  GroupController.swift
//  rally
//
//  Created by Jinyada on 22/24/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import Foundation
import CoreData

extension Member {
    
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.name = name
    }
    
}
