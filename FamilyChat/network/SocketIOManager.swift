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
    private let SOCKET_PROTOCOL = "message"
    
    
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
            self.connectedSocket?.onAny {
                print($0.items)
                if ($0.items != nil && $0.items!.count > 0) {
                    let message:String! = $0.items![0] as! String;
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
                }
            }
        }
    }
    
    private func regestAccountId(account:String?) {
        if (ValidationUtils.isValid(account) == false) {
            print("regestAccountId(), Input account is empty")
            return
        }
        
        Utils.synchronize(lockObj: SOCKET_LCOK) {
            if (self.connectedSocket == nil) {
                print("connected socket is null")
                return
            }
            
            let requestEntity:NSDictionary = [
                "api": API_ACCOUNT_ID,
                "accountId": account!
            ]
            
            self.connectedSocket?.emit(SOCKET_PROTOCOL, requestEntity)
        }
    }
    
    /*
 
     [weak self] is a capture list. It tells the compiler that the reference to self in this closure should not add to the reference count of self. This is so when the socket object goes out of scope, the capture made in the closure doesn’t keep it from being deallocated. The first parameter in all .on callbacks is an optional NSArray, it will contain all the data received with the event, or nil. The second parameter in the callback is an optional with the type of AckEmitter. AckEmitter is simply a typealias of (AnyObject...) -> Void. We’ll see this used later.
    */
}
