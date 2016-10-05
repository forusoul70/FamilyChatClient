//
//  SocketIOManager.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 25..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

private let _instance = SocketIOManager()

class SocketIOManager: NSObject {
    
//    fileprivate let SERVER_URL = "https://com-sanghwa-familychat.herokuapp.com/"
    private let SERVER_URL = "http://localhost:5000/"
    private let API_ACCOUNT_ID = "setAccountId"
    private let API_SEND_MESSAGE = "sendMessage"
    private let SOCKET_PROTOCOL = "message"
    private let CHAT_PROTOCOL = "chat"
    
    
    // instance member
    private let messageQue:OperationQueue = OperationQueue()
    private var connectedSocket:SocketIOClient?
    private let SOCKET_LCOK = NSObject()
    
    fileprivate override init() {

    }
    
    class var shared : SocketIOManager {
        return _instance
    }
    
    public func requestStart() {
        self.messageQue.addOperation {
            self.connect()
        }
    }
    
    public func requestRegiestAccountId(account:String!) {
        self.messageQue.addOperation {
            self.regestAccountId(account: account)
        }
    }
    
    public func requestSendMessage(to:String?, message:String?) {
        if (ValidationUtils.isValid(to) == false) {
            print("requestSendMessage(), input address to send is empty")
            return
        }
        
        if (ValidationUtils.isValid(message) == false) {
            print("requestSendMessage(), intpu message is empty")
            return
        }
        
        self.messageQue.addOperation {
            self.sendMessage(to:to, message:message)
        }
    }
    
    private func connect() {
        print("connect() requested socket io connectconnect")
        
        if (self.connectedSocket != nil) {
            print("startConnect(), Current sockcet is not nil")
            return 
        }
        
        let url = URL(string: SERVER_URL)
        Utils.synchronize(lockObj: self.SOCKET_LCOK) {
            self.connectedSocket = SocketIOClient(socketURL: url!)
            self.connectedSocket?.connect()
            
            self.connectedSocket?.onAny({(socketAnyEvent) in
                let event = socketAnyEvent.event;
                if (ValidationUtils.isValid(event) == false) {
                    return
                }
                
                let items = socketAnyEvent.items;
                if (event == self.CHAT_PROTOCOL) {
                    if (items == nil || items!.count == 0) {
                        return
                    }
                    
                    let message:String! = items![0] as! String;
                    let rawMessage = message.data(using: String.Encoding.utf8)
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: rawMessage!, options: []) as! [String: AnyObject]
                        let addressFrom = json["from"] as? String
                        let message = json["message"] as? String
                        
                        if (ValidationUtils.isValid(addressFrom) == false ||
                            ValidationUtils.isValid(message) == false) {
                            print("Failed to parse message from server \(message)")
                            return
                        }
                        
                        CoreDataHelper.insertMessage(addressFrom, body: message, isSend: false)
                    } catch {
                        abort()
                    }
                } else {
                    // TODO connection manage
                }
            })
        }
    }
    
    private func regestAccountId(account:String?) {
        if (ValidationUtils.isValid(account) == false) {
            print("regestAccountId(), Input account is empty")
            return
        }
        
        Utils.synchronize(lockObj: SOCKET_LCOK) {
            if (self.connectedSocket == nil) {
                print("sendMessage(), connected socket is null")
                return
            }
            
            let requestEntity:Dictionary<String, String> = [
                "api": API_ACCOUNT_ID,
                "accountId": account!
            ]
            sendSocket(requestEntity)
        }
    }
    
    private func sendMessage(to:String?, message:String?) {
        if (ValidationUtils.isValid(to) == false) {
            print("Input addess to send is empty")
            return
        }
        
        if (ValidationUtils.isValid(message) == false) {
            print("Input message is empty")
            return
        }
        
         Utils.synchronize(lockObj: SOCKET_LCOK) {
            if (self.connectedSocket == nil) {
                print("sendMessage(), connected socket is null")
                return
            }
            
            sendSocket(["api": API_SEND_MESSAGE, "messageToSend": message!,
                        "accountId": CoreDataHelper.shared.getCurrentUserId(), "accountIdTo": to!])
        }
    }
    
    private func sendSocket(_ requestEntity:[String : String]?) {
        if (requestEntity == nil) {
            print("Input request entity is null")
            return
        }
        self.connectedSocket?.emit(SOCKET_PROTOCOL, Utils.convertJsonStringWithDictionary(requestEntity))
    }
    
    /*
 
     [weak self] is a capture list. It tells the compiler that the reference to self in this closure should not add to the reference count of self. This is so when the socket object goes out of scope, the capture made in the closure doesn’t keep it from being deallocated. The first parameter in all .on callbacks is an optional NSArray, it will contain all the data received with the event, or nil. The second parameter in the callback is an optional with the type of AckEmitter. AckEmitter is simply a typealias of (AnyObject...) -> Void. We’ll see this used later.
    */
}
