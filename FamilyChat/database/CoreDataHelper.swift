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
    
    static func getMessageByTimestampList(_ timestampList:Array<Date>) -> Array<Message> {
        let fetchRequest = NSFetchRequest<NSManagedObject>()
        let entity = NSEntityDescription.entity(forEntityName: "Message", in: shared._managedContext)
        fetchRequest.entity = entity
        
        // sort 
        let sort:NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // selection
        var selection = ""
        for i in 0...(timestampList.count-1) {
            if (i > 0) {
                selection += " || "
            }
            let partSelection = "timestamp= CAST(\(timestampList[i].timeIntervalSinceReferenceDate),  \"NSDate\")"            
            selection += partSelection
        }

        fetchRequest.predicate = NSPredicate(format: selection)
        do {
            let result = try shared._managedContext.fetch(fetchRequest)
            return result as! [Message]
        } catch {
            
        }
        
        return Array<Message>()
    }
    
    static func getConversationList() -> Array<Message> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Edit the entity name as appropriate
        let entity = NSEntityDescription.entity(forEntityName: "Message", in: shared._managedContext)
        fetchRequest.entity = entity
        
        // sort
        let sort : NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // group by
        var expressionDescriptions = Array<AnyObject>()
        let expressionDescription:NSExpressionDescription = NSExpressionDescription()
        expressionDescription.name = "timestamp"
        expressionDescription.expression = NSExpression(format: "@max.timestamp")
        expressionDescriptions.append(expressionDescription)
        
        fetchRequest.propertiesToFetch = expressionDescriptions
        fetchRequest.propertiesToGroupBy = ["address"]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        do {
            var timestampList = [Date]()
            let queryResult = try shared._managedContext.fetch(fetchRequest) as! [Dictionary<String, AnyObject>]
            if (queryResult.count != 0) {
                for value in queryResult {
                    let dateDouble = Double(value[expressionDescription.name] as! String)
                    timestampList.append(Date(timeIntervalSinceReferenceDate: dateDouble!))
                }
                return getMessageByTimestampList(timestampList)
            }
        } catch {
            
        }
        
        return [Message]()
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
    
    static func insertNewFriendList(friendList:Array<Friends>) -> Void {
        if (friendList.count == 0) {
            print("deleteAllFriendAndInsertNew(), input friend list is empty");
            return
        }
        
        let currentUserId = shared.getCurrentUserId();
        if (ValidationUtils.isValid(currentUserId) == false) {
            print("deleteAllFriendAndInsertNew(), Failed to get current user id");
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Friends", in: shared._managedContext)!
        
        // first delete all
        let request = NSFetchRequest<Friends>();
        request.entity = entity
        request.predicate = NSPredicate(format: "friendWith = %@", currentUserId)
        do {
            let prevFriendList:Array<Friends> = try shared._managedContext.fetch(request)
            for prevFriend in prevFriendList {
                shared._managedContext.delete(prevFriend)
            }
        } catch {
            print("Failed to delete previous friend list");
            return
        }
        
        // insert new
        for friend in friendList {
            let newFriend:Friends = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: shared._managedContext) as! Friends
            
            newFriend.account = friend.account
            newFriend.friendWith = currentUserId;
        }
    }
    
    static func getAllFriendList() -> Array<Friends> {
        let currentUserId = shared.getCurrentUserId();
        if (ValidationUtils.isValid(currentUserId) == false) {
            print("Failed to get current user id")
            return Array<Friends>();
        }
        
        // Request
        let request = NSFetchRequest<Friends>();
        request.entity = NSEntityDescription.entity(forEntityName: "Friends", in: shared._managedContext)
        
        // predicate
        request.predicate = NSPredicate(format: "isFriend = %@", NSNumber(booleanLiteral: true))
        
        // sort
        let sort : NSSortDescriptor = NSSortDescriptor(key: "Accounts", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            return try shared._managedContext.fetch(request)
        } catch {
            return Array<Friends>();
        }
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
