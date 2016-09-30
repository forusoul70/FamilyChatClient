//
//  BroadcastManager.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 10. 1..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

private let _instance = BroadcastManager()

class BroadcastManager: NSObject {
    private var callbackDictionary = [String: [()->Void]] ()
    
    override init() {
        super.init()
        self.callbackDictionary = Dictionary()
        
    }
    
    class var shared : BroadcastManager {
        return _instance
    }
    
    public func addListener(eventName:String?, listener: @escaping  () -> Void) {
        if (ValidationUtils.isValid(eventName) == false) {
            print("addListener(), event name is null");
            return
        }
        
        var callArray:[()->Void]? = self.callbackDictionary[eventName!]
        if (callArray != nil) {
            callArray!.append(listener)
        } else {
            callArray = [()->Void]()
            callArray?.append(listener)
            self.callbackDictionary[eventName!] = callArray;
        }
    }
    
    public func sendEvnet(eventName:String?) {
        if (ValidationUtils.isValid(eventName) == false) {
            print("sendEvnet() event name is null")
            return
        }
        
        let callbackArray = self.callbackDictionary[eventName!]
        if (callbackArray != nil) {
            for callback in callbackArray! {
                callback()
            }
        }
    }
}
