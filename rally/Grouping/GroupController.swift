
//  GroupController.swift
//  rally
//
//  Created by Jinyada on 22/24/62.
//  Copyright © พ.ศ. 2562 Jinyada. All rights reserved.
//

import Foundation
import CoreData

public class RandomGroupController {
    
    private(set) var groups: [Group] = []
    var sizeTarget: Int
    var playgroundRules: Bool
    
    init(groupSizeTarget: Int, groupsOfOneFine: Bool){
        sizeTarget = groupSizeTarget
        playgroundRules = groupsOfOneFine
        //loadFromPersistentStore()
    }
    
    func createGroupsFrom(names: [String]){
        let nameSet: NSMutableOrderedSet = NSMutableOrderedSet(array: names)
        var newGroup = Group.init(members: NSOrderedSet())
        while nameSet.count > 0 {
            guard let selectedName = nameSet.object(at: random(min: 0, max: nameSet.count - 1)) as? String else{
                fatalError("Serious logic flaw. nameSet sould contain only strings. Contact the developer and give him a talking to.")
            }
            nameSet.remove(selectedName)
            let newMember = Member(name: selectedName)
            if newGroup.members.count == sizeTarget {

                groups.append(newGroup)
                
                
                newGroup = Group.init(members: NSOrderedSet())
            }
            if newGroup.members.count > 0 || nameSet.count > 0 || playgroundRules || sizeTarget == 1 {
                add(member: newMember, to: newGroup)
            }
            else{
                if let lastGroup = groups.last {
                    add(member: newMember, to: lastGroup)
                    NSLog("Adding member to old group to avoid creating a group of one.")
                }
                else{
                    NSLog("Creating a group of one could not be avoided because there was no existing group to add last member to.")
                }
            }
        }
        
        groups.append(newGroup)
        save()
    }
    
    func randomizeGroups() {
        var memberNames: [String] = []
        for group in groups {
            for member in group.members {
                guard let member = member as? Member else {
                    fatalError("Group Members Set should only contain Members.")
                }
                memberNames.append(member.name)
               
                CoreDataStack.context.delete(member)
            }
            CoreDataStack.context.delete(group)
        }
        groups = []

        createGroupsFrom(names: memberNames)
        save()
    }
    
    func nonRandomAddMember(withName name: String){
        let newMember = Member(name: name)
        if let lastGroup = groups.last, lastGroup.members.count < sizeTarget{
            add(member: newMember, to: lastGroup)
        }else{
            let newGroup = Group(members: NSOrderedSet())
            add(member: newMember, to: newGroup)
            groups.append(newGroup)
 
        }
        save()
    }
    
    func delete(member: Member){
        for group in groups {
            group.removeFromMembers(member)
            CoreDataStack.context.delete(member)
        }
        save()
    }
    
    private func add(member: Member, to group: Group){
        group.addToMembers(member)
        member.group = group
    }
    
    private func random(min: Int, max: Int) -> Int{
        let random = arc4random_uniform(UInt32(max) + 1 - UInt32(min)) + UInt32(min)
        return Int(random)
    }
    
    //MARK: - Persistence
    private func save(){
        do {
            try CoreDataStack.context.save()
        } catch let error {
            NSLog("Error saving groups: \(error.localizedDescription)")
        }
    }
    
}
