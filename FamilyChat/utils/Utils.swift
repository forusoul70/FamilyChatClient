//
//  Utils.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 25..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static func synchronize(lockObj: AnyObject!, closure: ()->()){
        objc_sync_enter(lockObj)
        closure()
        defer {
            objc_sync_exit(lockObj)
        }
    }
    
    static func convertJsonStringWithDictionary(_ dic:Dictionary<String, String>?) -> String {
        if (dic == nil) {
            return "";
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dic!, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String.init(data: data, encoding: String.Encoding.utf8)!
        } catch {
            print("convertJsonStringWithDictionary(), Failed")
            return ""
        }
    }

}
