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

private let _sharedManager = CoreDataHelper()

class CoreDataHelper: NSObject {
    private let _managedContext:NSManagedObjectContext!;
    
    override
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        _managedContext = delegate.managedObjectContext
    }
    
    class var shared : CoreDataHelper {
        return _sharedManager
    }
    
    static func getMessageByAddress(_ address:String!) -> NSFetchedResultsController<Message> {
        let fetchRequest = NSFetchRequest<Message>()
        // Edit the entity name as appropriate
        let entity = NSEntityDescription.entity(forEntityName: "Message", in: shared._managedContext)
        fetchRequest.entity = entity
        
        // set the batch size to suitable umber
        fetchRequest.predicate = NSPredicate(format: "address=%@", address)
        
        // sort
        let sort : NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // Edit the sort key as appropriate
        let aFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: shared._managedContext, sectionNameKeyPath: nil, cacheName: "getMessageByAddress_\(address)_\(shared.getCurrentUserId())")
        
        return aFetchedResultController
    }
    
    static func getAllConversation() -> Array<Message> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Message", in: shared._managedContext)
        fetchRequest.entity = entity
        
        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        var sortedMessageMap:Dictionary<String, Message> = Dictionary<String, Message>()
        do {
            let result = try shared._managedContext.fetch(fetchRequest) as! [Message]
            if (result.count > 0) {
                for message in result {
                    if (message.address != nil) {
                        let prevMessage = sortedMessageMap[message.address!];
                        if (prevMessage == nil
                            || prevMessage!.timestamp!.compare(message.timestamp! as Date) == ComparisonResult.orderedAscending) {
                            sortedMessageMap[message.address!] = message
                        }
                    }
                }
            }
            
            return sortedMessageMap.map({return $1});
        } catch {
            
        }
        
        return Array<Message>()
    }
    
    //TODO Grouping 해야함
    static func getConversationList() -> NSFetchedResultsController<Message> {
        let fetchRequest = NSFetchRequest<Message>()
        // Edit the entity name as appropriate
        let entity = NSEntityDescription.entity(forEntityName: "Message", in: shared._managedContext)
        fetchRequest.entity = entity
        
        // sort
        let sort : NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // group by
        var expressionDescriptions = [AnyObject]()
        var expressionDescription:NSExpressionDescription
        expressionDescriptions.append("address" as AnyObject)
        
        expressionDescription = NSExpressionDescription()
        expressionDescription.name = "body"
        expressionDescription.expression = NSExpression(format: "@max.timestamp")
        expressionDescription.expressionResultType = .integer32AttributeType
        expressionDescriptions.append(expressionDescription)
        
        fetchRequest.propertiesToFetch = expressionDescriptions
        fetchRequest.propertiesToGroupBy = ["address"]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        // Edit the sort key as appropriate
        let aFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: shared._managedContext, sectionNameKeyPath: nil, cacheName: "getConversationList_\(shared.getCurrentUserId())")
        
        return aFetchedResultController

    }
    
    static func insertMessage(_ address: String!, body: String!, isSend:Bool) -> Message {
        let entity = NSEntityDescription.entity(forEntityName: "Message", in: shared._managedContext)!
        let newMessage:Message = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: shared._managedContext) as! Message
        
        newMessage.timestamp = NSDate()
        newMessage.address = address
        newMessage.body = body
        newMessage.isSend = isSend
        
        // Save the context
        do {
            try shared._managedContext.save()
        } catch {
            abort()
        }
        
        BroadcastManager.shared.sendEvnet(eventName: "insertMessage")
        
        return newMessage
    }
    
    func getCurrentUserId() -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("preference").path
        
        if (FileManager.default.fileExists(atPath: fileURL) == false) {
            print("getCurrentUserId(), file is not exist")
            return ""
        }
        
        do {
            let account = try String(contentsOfFile: fileURL)
            if (ValidationUtils.isValid(account) == false) {
                print("getCurrentUserId(), account in file is empty");
                return ""
            }
            return account
        } catch {
            abort()
        }
    }
    
    func setAccountId(_ id:String?) {
        if (ValidationUtils.isValid(id) == false) {
            return
        }
        
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("preference")
            try id?.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            abort()
        }
    }
}
