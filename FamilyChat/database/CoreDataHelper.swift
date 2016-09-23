//
//  CoreDataHelper.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 11..
//  Copyright © 2016년 lee. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper: NSObject {
    
    static func getManagedObjectContext() -> NSManagedObjectContext {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    
    static func getMessageByAddress(address:String!) -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate
        let entity = NSEntityDescription.entityForName("Message", inManagedObjectContext: getManagedObjectContext())
        fetchRequest.entity = entity
        
        // set the batch size to suitable umber
        fetchRequest.predicate = NSPredicate(format: "address=%@", address)
        
        // sort
        let sort : NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // Edit the sort key as appropriate
        let aFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getManagedObjectContext(), sectionNameKeyPath: nil, cacheName: "getMessageByAddress_\(address)_\(getCurrentUserId())")
        
        return aFetchedResultController
    }
    
    //TODO Grouping 해야함
    static func getConversationList() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate
        let entity = NSEntityDescription.entityForName("Message", inManagedObjectContext: getManagedObjectContext())
        fetchRequest.entity = entity
        
        // sort
        let sort : NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // group by
        var expressionDescriptions = [AnyObject]()
        var expressionDescription:NSExpressionDescription
        expressionDescriptions.append("address")
        
        expressionDescription = NSExpressionDescription()
        expressionDescription.name = "body"
        expressionDescription.expression = NSExpression(format: "@max.timestamp")
        expressionDescription.expressionResultType = .Integer32AttributeType
        expressionDescriptions.append(expressionDescription)
        
        fetchRequest.propertiesToFetch = expressionDescriptions
        fetchRequest.propertiesToGroupBy = ["address"]
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        
        // Edit the sort key as appropriate
        let aFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getManagedObjectContext(), sectionNameKeyPath: nil, cacheName: "getConversationList_\(getCurrentUserId())")
        
        return aFetchedResultController

    }
    
    static func insertMessage(address: String!, body: String!, isSend:Bool) -> Message {
        let context = self.getManagedObjectContext()
        let entity = NSEntityDescription.entityForName("Message", inManagedObjectContext: context)!
        let newMessage:Message = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! Message
        
        newMessage.timestamp = NSDate()
        newMessage.address = address
        newMessage.body = body
        newMessage.isSend = NSNumber.init(bool: isSend)
        
        // Save the context
        do {
            try context.save()
        } catch {
            abort()
        }
        
        return newMessage
    }
    
    static func getCurrentUserId() -> String {
        //TODO FIXME 
        return "test"
    }
}
