//
//  CoversationModel.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 16..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class CoversationModel: NSObject {
    
    let address:String
    let snippetTimestamp:NSDate
    let snippetBody:String
    
    init(address:String, timestamp:NSDate, body:String) {
        self.address = address
        self.snippetTimestamp = timestamp
        self.snippetBody = body
    }
}
