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
//        fetchRequest.fetchBatchSize = 20
        fetchRequest.predicate = NSPredicate(format: "address=%@", address)
        
        // sort
        let sort : NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        // Edit the sort key as appropriate
        let aFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getManagedObjectContext(), sectionNameKeyPath: nil, cacheName: "getMessageByAddress_\(address)")
        
        return aFetchedResultController
    }
    
    static func insertMessage(message:Message) {
        let context = self.getManagedObjectContext()
        let entity = NSEntityDescription.entityForName("Message", inManagedObjectContext: context)!
        let newMessage = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
        
        newMessage.setValue(NSData(), forKey: "timestamp")
        
        // Save the context
        do {
            try context.save()
        } catch {
            abort()
        }
    }
}
