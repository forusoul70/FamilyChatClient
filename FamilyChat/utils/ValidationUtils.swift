//
//  ValidationUtils.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 13..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class ValidationUtils: NSObject {
    static func isValid(str:NSString?) -> Bool {
        if (str != nil && str?.length > 0) {
            return true
        }
        
        return false
    }
}
