
//  GroupController.swift
//  rally
//
//  Created by Jinyada on 22/24/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var name: String
    @NSManaged public var group: Group?

}
